pragma solidity ^0.4.18;
import "./LongShortController.sol";

/**
 * Manages all open option contracts,
 * and matches users and their funds to them.
 */
contract OrdersManager {
    
    // Secret for parameter matching
    string private signature = "mysaltisshitty";
    
    // List of all the controller contracts we have spawned
    address[] private controllers;
    
    // List of all open orders
    Order[] private openLongOrders;
    Order[] private openShortOrders;
    mapping(uint => uint) private longAmountForParameters;
    mapping(uint => uint) private shortAmountForParameters;
    
    // Address of the owner of this manager
    address private owner;
    
    // Address of the fee wallet
    address private feeWallet;
    
    // Constructor, defining the fee wallet address and the signature
    function OrdersManager(string signingSecret) public {
        owner = msg.sender;
        signature = signingSecret;
    }

    // Message, which is sent from the proxy contracts or straight from the user
    struct OrderParameters {
        uint expirationDate;
        uint closingSignature;
        uint8 leverage;
        bool longPosition;
        address paymentAddress;
    }
    
    // Matchable order, which gets stored in openOrders
    struct Order {
        uint parameterSignature;
        uint expirationDate;
        uint leverage;
        uint closingSignature;
        address originAddress;
        address paymentAddress;
        uint balance;
    }
    
    // Create an open order to wait for matching
    function createOrder(uint expirationDate, uint closingSignature, uint8 leverage, bool longPosition, address paymentAddress) public payable returns (uint) {
        require(msg.value > 0.1 ether);
        require(msg.value < 500 ether);
        uint parameterSignature = uint(keccak256(expirationDate, leverage, signature));
        if (longPosition) {
            openLongOrders.push(Order(parameterSignature, expirationDate, leverage, closingSignature, msg.sender, paymentAddress, msg.value));
            return openLongOrders.length - 1;
        } else {
            openShortOrders.push(Order(parameterSignature, expirationDate, leverage, closingSignature, msg.sender, paymentAddress, msg.value));
            return openShortOrders.length - 1;
        }
        return 0;
    }

    
    // Just for testing this without any events
    function getOrderStatus(uint orderID) public view returns (uint) {
        bool userIsLong = openLongOrders[orderID].originAddress == msg.sender;
        require(userIsLong || openShortOrders[orderID].originAddress == msg.sender);
        if (userIsLong) {
            return openLongOrders[orderID].parameterSignature;
        } else {
            return openShortOrders[orderID].parameterSignature;
        }
    }
    
    // Setter for our fee wallet address
    function setFeeWallet(address feeWalletAddress) public {
        require(msg.sender == owner);
        feeWallet = feeWalletAddress;
    }
    
    // Spawns a new option contract
    /* function createController(Order[] longOrders, Order[] shortOrders) public {
        var initialOrder = longOrders[0];
        address newController = new LongShortController(initialOrder.parameterSignature, initialOrder.expirationDate, initialOrder.leverage, longOrders, shortOrders);
        controllers.push(newController);
    } */
    
    function matchMaker() public {
        for (uint longOrderIndex = 0; longOrderIndex < openLongOrders.length; longOrderIndex++) {
            longAmountForParameters[openLongOrders[longOrderIndex].parameterSignature] += openLongOrders[longOrderIndex].balance;
        }
        assert(longAmountForParameters[openShortOrders[shortOrderIndex].parameterSignature] > 0.5 ether);
        for (uint shortOrderIndex = 0; shortOrderIndex < openShortOrders.length; shortOrderIndex++) {
            shortAmountForParameters[openShortOrders[shortOrderIndex].parameterSignature] += openShortOrders[shortOrderIndex].balance;
            if (shortAmountForParameters[openShortOrders[shortOrderIndex].parameterSignature] > 0.5 ether) {
                
            }
        }
    }

}
