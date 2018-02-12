pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./LongShortController.sol";
import "./Verify.sol";

/**
 * Manages all open option contracts,
 * and matches users and their funds to them.
 */
contract OrdersManager is Ownable {
    
    // Use Zeppelin's SafeMath library for calculations
    using SafeMath for uint256;

    // Secret for parameter matching
    string private signature = "mysaltisshitty";
    
    // List of all the controller contracts we have spawned
    address[] private controllers;
    
    // List of all open orders
    bytes32[] private openOrderHashes;
    mapping(bytes32 => Order[]) private longs;
    mapping(bytes32 => Order[]) private shorts;
    
    // Address of the fee wallet
    address private feeWallet;
    
    // Constructor, defining the fee wallet address and the signature
    function OrdersManager(string signingSecret) public {
        signature = signingSecret;
    }
    
    // Matchable order, which gets stored in openOrders
    struct Order {
        bytes32 parameterHash;
        uint closingDate;
        uint leverage;
        //bytes32 closingSignature;
        address originAddress;
        address paymentAddress;
        uint256 balance;
    }
    
     // Setter for our fee wallet address
    function setFeeWallet(address feeWalletAddress) public onlyOwner {
        feeWallet = feeWalletAddress;
    }

    // Create an open order to wait for matching
    function createOrder(uint closingDate, uint leverage, bool longPosition, address paymentAddress) public payable {
        //require(msg.value > 0.1 ether);
        require(msg.value < 500 ether);
        bytes32 parameterHash = keccak256(closingDate, leverage, signature);
        if (longPosition) {
            openOrderHashes.push(parameterHash);
            longs[parameterHash].push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));
        } else {
            openOrderHashes.push(parameterHash);
            shorts[parameterHash].push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));
        }
    }

    function matchMaker() public {
        require(openOrderHashes.length > 0);
        for (uint i = 0; i < openOrderHashes.length; i++) {
            bytes32 paramHash = openOrderHashes[i];
            uint256 amountLong = 0;
            uint256 amountShort = 0;

            require(longs[paramHash].length > 0);
            require(shorts[paramHash].length > 0);

            for (uint j = 0; j < longs[paramHash].length; j++) {
                amountLong.add(longs[paramHash][j].balance);
            }
            for (uint k = 0; k < shorts[paramHash].length; k++) {
                if (amountShort < amountLong) {
                    amountShort.add(shorts[paramHash][k].balance);
                }
            }

            uint256 amountForHash = amountLong.add(amountShort);
            uint256 feeForHash = amountForHash.mul(uint256(3).div(uint256(10)));
            amountForHash = amountForHash.sub(feeForHash);

            feeWallet.transfer(feeForHash);
        }
    }
    
    // Spawns a new option contract
    /* function createController(Order[] longOrders, Order[] shortOrders) public {
        var initialOrder = longOrders[0];
        address newController = new LongShortController(initialOrder.parameterHash, initialOrder.closingDate, initialOrder.leverage, longOrders, shortOrders);
        controllers.push(newController);
    } */

}
