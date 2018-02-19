pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";
import "./SafeMath.sol";
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

    // List of all open order types
    bytes32[] private openParameterHashes;
    // Order IDs mapped by parameter hash
    mapping(bytes32 => bytes32[]) private orderIDs;
    // Orders mapped by order ID
    mapping(bytes32 => Order) private orders;

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
        uint duration;
        uint leverage;
        address paymentAddress;
        uint256 balance;
        bytes32 ownerSignature;
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
     * Returns open parameter hashes
     *
     * @return bytes32[] array of open order types
     */
    function getOpenParameterHashes() public view onlyOwner returns (bytes32[]) {
        return openParameterHashes;
    }

    /**
     * Returns open orders by hash
     *
     * @return bytes32[] array of open orderIDs
     */
    function getOpenOrderIDs(bytes32 paramHash) public view onlyOwner returns (bytes32[]) {
        return orderIDs[paramHash];
    }

    /**
     * Returns order by orderID
     *
     * @return bool isLong
     * @return uint duration
     * @return uint leverage
     * @return address paymentAddress
     * @return uint256 balance
     */
    function getOrder(bytes32 orderHash) public view returns (bool, uint, uint, address, uint256) {
        Order memory order = orders[orderHash];
        return (order.isLong, order.duration, order.leverage, order.paymentAddress, order.balance);
    }

    /**
     * Function for checking if there are orders
     * with the same parameters open already
     *
     * @return bool
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
     * Open order creation, the main endpoint for Vanilla platform.
     *
     * Mainly called by Vanilla's own backend, but open for
     * everyone who knows how to use the smart contract on its own.
     *
     * Receives a singular payment with parameters to open an order with.
     */
    function createOrder(string orderID, bool isLong, uint duration, uint leverage, address paymentAddress) public payable returns (bytes32) {
        // Calculate a hash of the order to uniquely identify orders
        bytes32 orderHash = keccak256(orderID);

        // Require that there isn't an order with this ID yet
        require(orders[orderHash].paymentAddress == 0);

        // Check minimum and maximum bets
        require(msg.value >= MINIMUM_POSITION && msg.value <= MAXIMUM_POSITION);

        // Calculate a hash of the parameters for matching
        bytes32 parameterHash = keccak256(duration, leverage, signature);

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
        orders[orderHash] = Order(isLong, duration, leverage, paymentAddress, balance, keccak256(msg.sender));

        debug("New order received and saved.");
        return orderHash;
    }

    function deleteOrder(bytes32 orderHash) public onlyOwner {
        require(orders[orderHash].balance == 0);
        delete orders[orderHash];
    }

    function updateOrderBalance(bytes32 orderHash, uint256 newBalance) public onlyOwner {
        Order memory modifiedOrder = orders[orderHash];
        modifiedOrder.balance = newBalance;
        orders[orderHash] = modifiedOrder;
    }
}
