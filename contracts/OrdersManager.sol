pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./LongShortController.sol";
import "./Verify.sol";

/**
 * Manages all open option contracts,
 * and matches users and their funds to them.
 */
contract OrdersManager is Ownable {
    
    // Secret for parameter matching
    string private signature = "mysaltisshitty";
    
    // List of all the controller contracts we have spawned
    address[] private controllers;
    
    // List of all open orders
    Order[] private openLongOrders;
    Order[] private openShortOrders;
    mapping(uint => uint) private longAmountForParameters;
    mapping(uint => uint) private shortAmountForParameters;
    
    // Address of the fee wallet
    address private feeWallet;
    
    // Constructor, defining the fee wallet address and the signature
    function OrdersManager(string signingSecret) public {
        signature = signingSecret;
    }

    // Message, which is sent from the proxy contracts or straight from the user
    struct OrderParameters {
        uint closingDate;
        //bytes32 closingSignature;
        uint8 leverage;
        bool longPosition;
        address paymentAddress;
    }
    
    // Matchable order, which gets stored in openOrders
    struct Order {
        uint parameterHash;
        uint closingDate;
        uint leverage;
        //bytes32 closingSignature;
        address originAddress;
        address paymentAddress;
        uint balance;
    }
    
    // Create an open order to wait for matching
    function createOrder(uint closingDate, uint leverage, bool longPosition, address paymentAddress) public payable returns (uint) {
        //require(msg.value > 0.1 ether);
        require(msg.value < 500 ether);
        uint parameterHash = uint(keccak256(closingDate, leverage, signature));
        if (longPosition) {
            openLongOrders.push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));
            return openLongOrders.length - 1;
        } else {
            openShortOrders.push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));
            return openShortOrders.length - 1;
        }
        return 0;
    }

    
    // Just for testing this without any events
    function getOrderStatus(uint orderID) public view returns (uint) {
        bool userIsLong = openLongOrders[orderID].originAddress == msg.sender;
        require(userIsLong || openShortOrders[orderID].originAddress == msg.sender);
        if (userIsLong) {
            return openLongOrders[orderID].parameterHash;
        } else {
            return openShortOrders[orderID].parameterHash;
        }
    }
    
    // Setter for our fee wallet address
    function setFeeWallet(address feeWalletAddress) public onlyOwner {
        feeWallet = feeWalletAddress;
    }
    
    // Spawns a new option contract
    /* function createController(Order[] longOrders, Order[] shortOrders) public {
        var initialOrder = longOrders[0];
        address newController = new LongShortController(initialOrder.parameterHash, initialOrder.closingDate, initialOrder.leverage, longOrders, shortOrders);
        controllers.push(newController);
    } */
    
    function matchMaker() public {
        for (uint longOrderIndex = 0; longOrderIndex < openLongOrders.length; longOrderIndex++) {
            longAmountForParameters[openLongOrders[longOrderIndex].parameterHash] += openLongOrders[longOrderIndex].balance;
        }
        assert(longAmountForParameters[openShortOrders[shortOrderIndex].parameterHash] > 0.5 ether);
        for (uint shortOrderIndex = 0; shortOrderIndex < openShortOrders.length; shortOrderIndex++) {
            shortAmountForParameters[openShortOrders[shortOrderIndex].parameterHash] += openShortOrders[shortOrderIndex].balance;
            if (shortAmountForParameters[openShortOrders[shortOrderIndex].parameterHash] > 0.5 ether) {
                
            }
        }
    }

}
