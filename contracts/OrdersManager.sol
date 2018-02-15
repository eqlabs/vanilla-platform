pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";
import "./SafeMath.sol";
import "./LongShortController.sol";
//import "./Verify.sol";

/**
 * Handles opening and bundling of orders into active LongShort contracts.
 * New orders' parameters are grouped by a hash of the parameters,
 * with which a matchMaker function bundles open orders and closes ones that have expired.
 *
 * @author Convoluted Labs
 */
contract OrdersManager is Ownable, Debuggable {
    
    // Use Zeppelin's SafeMath library for calculations
    using SafeMath for uint256;

    // Secret for parameter matching
    string private signature = "mysaltisshitty";

    // Address of the fee wallet
    address private feeWallet;
    uint256 private cumulatedFee;

    // Address of the LongShortController
    address private longShortControllerAddress;
    LongShortController private controller;
    
    // List of all open order types
    bytes32[] private openOrderHashes;

    // Orders mapped by parameter group
    mapping(bytes32 => Order[]) private longs;
    mapping(bytes32 => Order[]) private shorts;

    // Order balances mapped by parameter group
    mapping(bytes32 => uint256) private amountLongForHash;
    mapping(bytes32 => uint256) private amountShortForHash;

    // Minimum and maximum positions
    uint256 public constant MINIMUM_POSITION = 0.01 ether;
    uint256 public constant MAXIMUM_POSITION = 500 ether;

    // Fee percentage
    uint8 private constant FEE_PERCENTAGE = 30;
    
    /**
     * Order struct
     * Constructed in createOrder() with user parameters
     */
    struct Order {
        bytes32 parameterHash;
        uint closingDate;
        uint leverage;
        //bytes32 closingSignature;
        address originAddress;
        address paymentAddress;
        uint256 balance;
    }
    
    /**
     * Setter for Vanilla's fee wallet address
     * Only callable by the owner.
     */
    function setFeeWallet(address feeWalletAddress) public onlyOwner {
        feeWallet = feeWalletAddress;
        debug("Fee wallet set.");
    }

    /**
     * Setter for Vanilla's LongShortController
     */
    function setLongShortController() public onlyOwner {
        longShortControllerAddress = new LongShortController();
        controller = LongShortController(longShortControllerAddress);
        bytes32 check = controller.checkConstructor();
        require(check == keccak256(this));
        debug("Controller set.");
    }

    /**
     * Setter for the contract signature
     */
    function setSignature(string signingSecret) public onlyOwner {
        signature = signingSecret;
        debug("Signature set.");
    }

    /**
     * Fee calculation function
     */
    function calculateFee(uint256 amount) internal pure returns (uint256) {
        return amount.mul(FEE_PERCENTAGE).div(100);
    }

    /**
     * Pull payment function for sending
     * the accumulated fees to Vanilla's fee wallet
     */
    function withdrawFee() public onlyOwner {
        require(cumulatedFee > 0 wei);
        feeWallet.transfer(cumulatedFee);
        cumulatedFee = 0;
        debug("Fees withdrawn.");
    }

    /**
     * Getter for the LongShortController address
     * 
     * @return address address of the LongShortController
     */
    function getControllerAddress() public view onlyOwner returns (address) {
        return longShortControllerAddress;
    }

    /**
     * Tool function for debugging. Could be used in the backend. For something.
     * 
     * @return bytes32[] array of open order types
     */
    function getOpenOrderHashes() public view onlyOwner returns (bytes32[]) {
        return openOrderHashes;
    }

    /**
     * Function for checking if there are orders
     * with the same parameters open already
     * 
     * @return bool
     */
    function similarOrdersExist(bytes32 parameterHash) private returns (bool) {
        if (amountShortForHash[parameterHash] > 0 wei || amountLongForHash[parameterHash] > 0 wei) {
            debug("Similar orders exist.");
            return true;
        }
        debug("No similar orders exist.");
        return false;
    }

    /**
     * Function for checking if there are open orders
     * on both sides with enough funds.
     * 
     * @return bool
     */
    function matchesExist(bytes32 parameterHash) private returns (bool) {
        if (amountShortForHash[parameterHash] >= MINIMUM_POSITION && amountLongForHash[parameterHash] >= MINIMUM_POSITION) {
            debug("Matches exist.");
            return true;
        }
        debug("No matches exist.");
        return false;
    }

    /**
     * Open order creation, the main endpoint for Vanilla platform.
     *
     * Mainly called by Vanilla's own backend, but open for
     * everyone who knows how to use the smart contract on its own.
     *
     * Receives a singular payment with parameters to open an order with.
     */
    function createOrder(uint closingDate, uint leverage, bool longPosition, address paymentAddress) public payable {

        // Check minimum and maximum bets
        require(msg.value >= MINIMUM_POSITION && msg.value <= MAXIMUM_POSITION);

        // Calculate a hash of the parameters for matching
        bytes32 parameterHash = keccak256(closingDate, leverage, signature);

        /* SAVE ORDER */

        // If the order is long
        if (longPosition) {

            // Save new parameter hash to list
            if (!similarOrdersExist(parameterHash)) {
                openOrderHashes.push(parameterHash);
            }

            // Add the sent amount to previous amount of longs with the same parameters
            amountLongForHash[parameterHash] = amountLongForHash[parameterHash].add(msg.value);

            // Add the order to list of open long orders
            longs[parameterHash].push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));

            debug("New long position received and saved.");

        // If the order is short
        } else {

            // Save new parameter hash to list
            if (!similarOrdersExist(parameterHash)) {
                openOrderHashes.push(parameterHash);
            }

            // Add the sent amount to previous amount of shorts with the same parameters
            amountShortForHash[parameterHash] = amountShortForHash[parameterHash].add(msg.value);

            // Add the order to list of open short orders
            shorts[parameterHash].push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));

            debug("New short position received and saved.");

        }

    }

    /**
     * Public callable matchmaker function, which has the logic
     * for creating new active LongShorts from open orders
     * 
     * Accessible by everyone on the Ethereum blockchain, so that
     * nobody's funds are freezed in any situation.
     */
    function matchMaker() public {

        // Fail the call if there's no open orders
        require(openOrderHashes.length > 0);

        debug("There are more than 1 open orders.");

        // Iterate over all parameter groups
        for (uint i = 0; i < openOrderHashes.length; i++) {

            // Parameter hash of this iteration
            bytes32 paramHash = openOrderHashes[i];

            // Order arrays for these parameters
            Order[] memory longsForHash = new Order[](longs[paramHash].length);
            Order[] memory shortsForHash = new Order[](shorts[paramHash].length);

            debug("Checking an order hash.");

            // Check that both sides have open orders with same parameters
            if (matchesExist(paramHash)) {

                // If there's more ETH in long orders
                if (amountShortForHash[paramHash] < amountLongForHash[paramHash]) {
                    debug("There's more ETH in long orders.");

                    // Since there's more ETH in long, let's iterate over long orders
                    // to enable partial matching
                    uint256 amountLong = 0;

                    // Use the straight amount straight from the chain
                    uint256 amountShort = amountShortForHash[paramHash];

                    // Calculate the difference of amounts in long and short orders
                    uint256 longShortDiff = amountLongForHash[paramHash].sub(amountShort);

                    // For the smaller position, it's easy: just add the orders to the batch.
                    for (uint j = 0; j < shorts[paramHash].length; j++) {

                        // Add the order straight in the bundle
                        shortsForHash[j] = shorts[paramHash][j];

                        // Subtract the order balance from manager balances
                        amountShortForHash[paramHash] = amountShortForHash[paramHash].sub(shorts[paramHash][j].balance);

                        // Remove the completely matched order from manager's order book
                        delete shorts[paramHash][j];

                    }

                    // For the larger position, let's calculate a little
                    for (j = 0; j < longs[paramHash].length; j++) {

                        // If there's still some ETH to match on the long side
                        if (amountLong < amountShort) {

                            // Check if the balance in the current long order is less
                            // than the difference between long and short orders
                            if (longs[paramHash][j].balance < longShortDiff) {
                                
                                // Add the order balance to amountLong
                                amountLong = amountLong.add(longs[paramHash][j].balance);

                                // Add the order straight in the bundle
                                longsForHash[j] = longs[paramHash][j];

                                // Subtract the order balance from manager balances
                                amountLongForHash[paramHash] = amountLongForHash[paramHash].sub(longs[paramHash][j].balance);

                                // Remove the completely matched order from manager's order book
                                delete longs[paramHash][j];

                            // If the amount of ETH in the current order is more
                            // than the difference between long and short orders
                            } else {

                                // Calculate the remaining fillable balance
                                var remainingDiff = amountShort.sub(amountLong);
                                
                                // Create a new partial order as a copy of the original in memory
                                Order memory partialOrder = longs[paramHash][j];
                                // Set the partial order balance as the remaining fillable balance
                                partialOrder.balance = remainingDiff;

                                // Subtract the partial order balance from the original order
                                longs[paramHash][j].balance = longs[paramHash][j].balance.sub(remainingDiff);

                                // Add the partial order in the bundle
                                longsForHash[j] = partialOrder;

                                // Subtract the partial order balance from manager balances
                                amountLongForHash[paramHash] = amountLongForHash[paramHash].sub(remainingDiff);

                                // Set amountLong as same as amountShort, filling the balance in the bundle
                                amountLong = amountShort;

                            }

                        }
                    }

                // Same logic as before but with the roles changed
                } else {

                    debug("There's more ETH in short orders.");

                    amountLong = amountLongForHash[paramHash];
                    amountShort = 0;

                    var shortLongDiff = amountShortForHash[paramHash].sub(amountLong);

                    // For the smaller position, it's easy: just add the orders to the batch.
                    for (j = 0; j < longs[paramHash].length; j++) {
                        longsForHash[j] = longs[paramHash][j];
                        amountLongForHash[paramHash] = amountLongForHash[paramHash].sub(longs[paramHash][j].balance);
                        delete longs[paramHash][j];
                    }

                    // For the larger position, let's calculate a little
                    for (j = 0; j < shorts[paramHash].length; j++) {
                        if (amountShort < amountLong) {

                            if (shorts[paramHash][j].balance < shortLongDiff) {

                                amountShort = amountShort.add(shorts[paramHash][j].balance);
                                shortsForHash[j] = shorts[paramHash][j];
                                amountShortForHash[paramHash] = amountShortForHash[paramHash].sub(shorts[paramHash][j].balance);
                                delete shorts[paramHash][j];

                            } else {

                                remainingDiff = amountLong.sub(amountShort);

                                partialOrder = shorts[paramHash][j];
                                partialOrder.balance = remainingDiff;

                                shorts[paramHash][j].balance = shorts[paramHash][j].balance.sub(remainingDiff);

                                shortsForHash[j] = partialOrder;
                                amountShortForHash[paramHash] = amountShortForHash[paramHash].sub(remainingDiff);
                                
                                amountShort = amountLong;

                            }

                        }
                    }

                }

                debug("Calculating payments.");

                // Initialize the amount sent to the active contract
                uint256 amountForHash = amountLong.add(amountShort);

                // Calculate the fee (30% of the active contract amount)
                uint256 feeForHash = calculateFee(amountForHash);

                // Subtract the fee from the active contract amount
                amountForHash = amountForHash.sub(feeForHash);

                // Save the fee to the contract
                cumulatedFee = cumulatedFee.add(feeForHash);

                //longShortControllerAddress.transfer(amountForHash);
            }
        }
    }
}
