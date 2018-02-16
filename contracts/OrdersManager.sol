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
    mapping(bytes32 => Order[]) private orders;

    // Balances by user
    mapping(address => uint256) public balances;

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
        bool isLong;
        bytes32 parameterHash;
        uint closingDate;
        uint leverage;
        bytes32 ownerSignature;
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
     * Returns open order hashes
     * 
     * @return bytes32[] array of open order types
     */
    function getOpenOrderHashes() public view onlyOwner returns (bytes32[]) {
        return openOrderHashes;
    }

    /**
     * Returns open orders by hash
     * 
     * @return bytes32[] array of open order types
     */
    function getOpenOrders(bytes32 paramHash) public view onlyOwner returns (Order[]) {
        return orders[paramHash];
    }

    /**
     * Function for checking if there are orders
     * with the same parameters open already
     * 
     * @return bool
     */
    function similarOrdersExist(bytes32 parameterHash) private returns (bool) {
        for (uint8 i = 0; i < openOrderHashes.length; i++) {
            if (openOrderHashes[i] == parameterHash) {
                debug("Similar orders exist.");
                return true;
            }
        }
        debug("No similar orders exist.");
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
    function createOrder(uint closingDate, uint leverage, bool isLong, address paymentAddress) public payable {

        // Check minimum and maximum bets
        require(msg.value >= MINIMUM_POSITION && msg.value <= MAXIMUM_POSITION);

        // Calculate a hash of the parameters for matching
        bytes32 parameterHash = keccak256(closingDate, leverage, signature);

        /* SAVE ORDER */

        // Save new parameter hash to list
        if (!similarOrdersExist(parameterHash)) {
            openOrderHashes.push(parameterHash);
        }

        uint256 fee = calculateFee(msg.value);
        uint256 userBet = msg.value.sub(fee);

        cumulatedFee = cumulatedFee.add(fee);

        // Add the order to list of open long orders
        orders[parameterHash].push(Order(isLong, parameterHash, closingDate, leverage, keccak256(msg.sender), msg.sender, paymentAddress, userBet));

        if (isLong) {
            debug("New long position received and saved.");
        } else {
            debug("New short position received and saved.");
        }

    }
}
