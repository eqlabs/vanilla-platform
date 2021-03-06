pragma solidity ^0.4.26;
import "./Ownable.sol";
import "./Validatable.sol";
import "./SafeMath.sol";
//import "./Verify.sol";

/**
@dev Handles opening and bundling of orders into active LongShort contracts.
New orders' parameters are grouped by a hash of the parameters,
with which a matchMaker function bundles open orders and closes ones that have expired.

@author Convoluted Labs
*/
contract OrdersManager is Ownable, Validatable {

    // Use Zeppelin's SafeMath library for calculations
    using SafeMath for uint256;

    // Secret for parameter matching
    bytes32 private signature = "mysaltisshitty";

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

    /**
    @dev Order struct
    Constructed in createOrder() with user parameters
    */
    struct Order {
        bytes7 currencyPair;
        bytes5 positionType;
        uint duration;
        uint expiryTime;
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
    }

    /**
    @dev Setter for the contract signature
    Only callable by the owner.

    @param signingSecret a salt used in parameter and order hashing
    */
    function setSignature(bytes32 signingSecret) public onlyOwner {
        signature = signingSecret;
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
        uint256 fee = cumulatedFee;
        cumulatedFee = 0;
        require(fee > 0 wei, "Fee must be larger than 0!");
        feeWallet.transfer(fee);
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

    @param orderID An unique hash that maps to an order
    @return {
        "currencyPair": "describing the currency pair of the order",
        "positionType": "describing if the order is 'LONG' or 'SHORT'",
        "duration": "duration of the order in seconds",
        "leverage": "leverage of the LongShort",
        "paymentAddress": "address to which the refunds and rewards are paid",
        "balance": "balance of the order"
    }
    */
    function getOrder(bytes32 orderID) public view returns (bytes7, bytes5, uint, uint, address, uint256) {
        Order memory order = orders[orderID];
        return (order.currencyPair, order.positionType, order.duration, order.leverage, order.paymentAddress, order.balance);
    }

    /**
    @dev Function for checking if there are orders
    with the same parameters open already

    @param parameterHash Hash of duration, leverage and signature.
    @return bool
    */
    function parameterHashExists(bytes32 parameterHash) private view returns (bool) {
        return orderIDs[parameterHash].length > 0;
    }

    /**
    @dev Open order creation, the main endpoint for Vanilla platform.

    Mainly called by Vanilla's own backend, but open for
    everyone who knows how to use the smart contract on its own.

    Receives a singular payment with parameters to open an order with.

    @param orderID A unique bytes32 ID to create the order with.
    @param currencyPair "ETH-USD" || "BTC-USD"
    @param positionType "LONG" || "SHORT"
    @param duration Duration of the LongShort in seconds. For example, 14 days = 1209600
    @param leverage uint of the wanted leverage
    @param paymentAddress address, to which the user wants the funds back whether he/she won or not
    */
    function createOrder(bytes32 orderID, bytes7 currencyPair, bytes5 positionType, uint duration, uint8 leverage, address paymentAddress) public payable {

        // Require that there isn't an order with this ID yet
        require(orders[orderID].paymentAddress == 0, "An order with this ID already exists!");

        // Check minimum and maximum bets
        require(msg.value >= MINIMUM_POSITION && msg.value <= MAXIMUM_POSITION, "Order amount not allowed!");

        // Calculate a hash of the parameters for matching
        bytes32 parameterHash = keccak256(abi.encodePacked(currencyPair, duration, leverage, signature));

        validateLeverage(leverage);

        /* SAVE ORDER */

        // Save new parameter hash to list
        if (!parameterHashExists(parameterHash)) {
            openParameterHashes.push(parameterHash);
        }

        uint256 fee = calculateFee(msg.value);
        uint256 balance = msg.value.sub(fee);

        cumulatedFee = cumulatedFee.add(fee);

        // Map the orderID to paramHash
        orderIDs[parameterHash].push(orderID);
        // Map the order to the orderID
        orders[orderID] = Order(currencyPair, positionType, duration, block.timestamp.add(12 hours), leverage, paymentAddress, balance, keccak256(abi.encodePacked(msg.sender)));
    }

    /**
    @dev Deletes an order by hash,
    effectively turning all its parameters to 0.
    Used by the backend after an order has been fully matched.
    Only callable by the owner.

    @param orderID The unique hash of the deletable order.
    */
    function deleteOrder(bytes32 orderID) public onlyOwner {
        require(orders[orderID].balance == 0, "Only orders with 0 balance can be deleted!");
        delete orders[orderID];
    }

    /**
    @dev Refunds an order by hash after its expiry

    @param orderID The unique hash of the deletable order.
    */
    function refund(bytes32 orderID) public {
        require(orders[orderID].expiryTime < block.timestamp, "Order must be expired to be refunded.");
        require(orders[orderID].balance > 0, "Order must have more than 0 balance to be refunded.");
        address paymentAddress = orders[orderID].paymentAddress;
        uint256 balance = orders[orderID].balance;
        delete orders[orderID];
        paymentAddress.transfer(balance);
    }

    /**
    @dev Updates an order's balance.
    Used by the backend when an order was partially matched.
    Only callable by the owner.

    @param orderID The unique hash of the deletable order.
    @param newBalance The new balance of an order.
    */
    function updateOrderBalance(bytes32 orderID, uint256 newBalance) public onlyOwner {
        Order memory modifiedOrder = orders[orderID];
        modifiedOrder.balance = newBalance;
        orders[orderID] = modifiedOrder;
    }
}
