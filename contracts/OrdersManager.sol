pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";
import "./SafeMath.sol";
//import "./Verify.sol";

/**
@dev Handles opening and bundling of orders into active LongShort contracts.
New orders' parameters are grouped by a hash of the parameters,
with which a matchMaker function bundles open orders and closes ones that have expired.

@author Convoluted Labs
*/
contract OrdersManager is Ownable, Debuggable {

    // Use Zeppelin's SafeMath library for calculations
    using SafeMath for uint256;

    // Secret for parameter matching
    string private signature = "mysaltisshitty";

    // Address of the fee wallet
    address private feeWallet;
    uint256 private cumulatedFee;

    // List of all open order types
    bytes32[] private openParameterHashes;
    // Order IDs mapped by parameter hash
    mapping(bytes32 => bytes32[]) private orderIDs;
    // Orders mapped by order ID
    mapping(bytes32 => Order) private orders;

    // Minimum and maximum positions
    uint256 public constant MINIMUM_POSITION = 0.01 ether;
    uint256 public constant MAXIMUM_POSITION = 5 ether;

    // Fee percentage
    uint8 private constant FEE_PERCENTAGE = 3;

    // Allowed order types
    string[] public POSITION_TYPES = [ "LONG", "SHORT" ];

    // Allowed currency pairs
    string[] public CURRENCY_PAIRS = [ "ETH-USD", "BTC-USD" ];

    // Allowed currency pairs
    uint8[] public LEVERAGES = [ 2, 5 ];

    /**
    @dev Order struct
    Constructed in createOrder() with user parameters
    */
    struct Order {
        string currencyPair;
        string positionType;
        uint duration;
        uint leverage;
        address paymentAddress;
        uint256 balance;
        bytes32 ownerSignature;
    }

    /**
    @dev Setter for Vanilla's fee wallet address
    Only callable by the owner.
    
    @param feeWalletAddress upcoming address that receives the fees
    */
    function setFeeWallet(address feeWalletAddress) public onlyOwner {
        feeWallet = feeWalletAddress;
        debug("Fee wallet set.");
    }

    /**
    @dev Setter for the contract signature
    Only callable by the owner.
    
    @param signingSecret a salt used in parameter and order hashing
    */
    function setSignature(string signingSecret) public onlyOwner {
        signature = signingSecret;
        debug("Signature set.");
    }

    /**
    @dev Fee calculation function
    
    @param amount the total amount that the fee is calculated from
    */
    function calculateFee(uint256 amount) internal pure returns (uint256) {
        return amount.mul(FEE_PERCENTAGE).div(100);
    }

    /**
    @dev Pull payment function for sending
    the accumulated fees to Vanilla's fee wallet.
    Only callable by the owner.
    */
    function withdrawFee() public onlyOwner {
        require(cumulatedFee > 0 wei);
        feeWallet.transfer(cumulatedFee);
        cumulatedFee = 0;
        debug("Fees withdrawn.");
    }

    /**
    @dev Returns open parameter hashes.
    Only callable by the owner.
    
    @return {
        "openParameterHashes": "A bytes32 array of open order types"
    }
    */
    function getOpenParameterHashes() public view onlyOwner returns (bytes32[]) {
        return openParameterHashes;
    }

    /**
    @dev Returns open orders by hash
    Only callable by the owner.

    @param paramHash Hash of duration, leverage and signature.
    @return {
        "orderIDs[paramHash]": "A bytes32 array of open order IDs for the parameters"
    }
    */
    function getOpenOrderIDs(bytes32 paramHash) public view onlyOwner returns (bytes32[]) {
        return orderIDs[paramHash];
    }

    /**
    @dev Returns order by orderID.
    Deconstructs the Order struct for returning. Leaves out the ownerSignature.
     
    @param orderHash An unique hash that maps to an order
    @return {
        "currencyPair": "string, describing the currency pair of the order",
        "positionType": "string, describing if the order is 'LONG' or 'SHORT'",
        "duration": "uint, duration of the order in seconds",
        "leverage": "uint, leverage of the LongShort",
        "paymentAddress": "address, to which the refunds and rewards are paid",
        "balance": "uint256, balance of the order"
    }
    */
    function getOrder(bytes32 orderHash) public view returns (string, string, uint, uint, address, uint256) {
        Order memory order = orders[orderHash];
        return (order.currencyPair, order.positionType, order.duration, order.leverage, order.paymentAddress, order.balance);
    }

    /**
    @dev Function for checking if there are orders
    with the same parameters open already
    
    @param parameterHash Hash of duration, leverage and signature.
    @return bool
    */
    function parameterHashExists(bytes32 parameterHash) private returns (bool) {
        if (orderIDs[parameterHash].length > 0) {
            debug("Parameter hash exists.");
            return true;
        }
        debug("Parameter hash doesn't exist.");
        return false;
    }

    /**
    @dev A function that compares two strings for equality.
    Hashes first and second with keccak256 and checks if the hashes are equal.
    */
    function stringsAreEqual(string first, string second) internal pure returns (bool) {
        return keccak256(first) == keccak256(second);
    }

    /**
    @dev Open order creation, the main endpoint for Vanilla platform.
    
    Mainly called by Vanilla's own backend, but open for
    everyone who knows how to use the smart contract on its own.
    
    Receives a singular payment with parameters to open an order with.
    
    @param orderID A unique ID to create the order with. Will be hashed.
    @param currencyPair "ETH-USD" || "BTC-USD"
    @param positionType "LONG" || "SHORT"
    @param duration Duration of the LongShort in seconds. For example, 14 days = 1209600
    @param leverage uint of the wanted leverage
    @param paymentAddress address, to which the user wants the funds back whether he/she won or not
    @return {
        "orderHash": "Hashed unique ID for the new order"
    }
    */
    function createOrder(string orderID, string currencyPair, string positionType, uint duration, uint8 leverage, address paymentAddress) public payable returns (bytes32) {
        // Calculate a hash of the order to uniquely identify orders
        bytes32 orderHash = keccak256(orderID);

        // Require that there isn't an order with this ID yet
        require(orders[orderHash].paymentAddress == 0);

        // Check minimum and maximum bets
        require(msg.value >= MINIMUM_POSITION && msg.value <= MAXIMUM_POSITION);

        // Calculate a hash of the parameters for matching
        bytes32 parameterHash = keccak256(duration, leverage, signature);

        // Check currencyPair against allowed pairs
        bool currencyFound = false;
        for (uint8 i = 0; i < CURRENCY_PAIRS.length; i++) {
            if (stringsAreEqual(currencyPair, CURRENCY_PAIRS[i])) {
                currencyFound = true;
            }
        }
        require(currencyFound);

        // Check positionType against allowed types
        bool positionTypeFound = false;
        for (i = 0; i < POSITION_TYPES.length; i++) {
            if (stringsAreEqual(positionType, POSITION_TYPES[i])) {
                positionTypeFound = true;
            }
        }
        require(positionTypeFound);

        // Check leverage against allowed amounts
        bool allowedLeverage = false;
        for (i = 0; i < LEVERAGES.length; i++) {
            if (leverage == LEVERAGES[i]) {
                allowedLeverage = true;
            }
        }
        require(allowedLeverage);

        /* SAVE ORDER */

        // Save new parameter hash to list
        if (!parameterHashExists(parameterHash)) {
            openParameterHashes.push(parameterHash);
        }

        uint256 fee = calculateFee(msg.value);
        uint256 balance = msg.value.sub(fee);

        cumulatedFee = cumulatedFee.add(fee);

        // Map the orderHash to paramHash
        orderIDs[parameterHash].push(orderHash);
        // Map the order to the orderHash
        orders[orderHash] = Order(currencyPair, positionType, duration, leverage, paymentAddress, balance, keccak256(msg.sender));

        debug("New order received and saved.");
        return orderHash;
    }

    /**
    @dev Deletes an order by hash,
    effectively turning all its parameters to 0.
    Used by the backend after an order has been fully matched.
    Only callable by the owner.
    
    @param orderHash The unique hash of the deletable order.
    */
    function deleteOrder(bytes32 orderHash) public onlyOwner {
        require(orders[orderHash].balance == 0);
        delete orders[orderHash];
    }

    /**
    @dev Updates an order's balance.
    Used by the backend when an order was partially matched.
    Only callable by the owner.
    
    @param orderHash The unique hash of the deletable order.
    @param newBalance The new balance of an order.
    */
    function updateOrderBalance(bytes32 orderHash, uint256 newBalance) public onlyOwner {
        Order memory modifiedOrder = orders[orderHash];
        modifiedOrder.balance = newBalance;
        orders[orderHash] = modifiedOrder;
    }
}
