pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./LongShortController.sol";
import "./Verify.sol";

/**
 * Handles opening and bundling of orders into active LongShort contracts.
 * New orders' parameters are grouped by a hash of the parameters,
 * with which a matchMaker function bundles open orders and closes ones that have expired.
 *
 * @author Convoluted Labs
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

        // Define minimum and maximum bets
        //require(msg.value > 0.1 ether);
        require(msg.value < 500 ether);

        // Calculate a hash of the parameters for matching
        bytes32 parameterHash = keccak256(closingDate, leverage, signature);

        // Register position types into own arrays and maps
        if (longPosition) {
            openOrderHashes.push(parameterHash);
            longs[parameterHash].push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));
        } else {
            openOrderHashes.push(parameterHash);
            shorts[parameterHash].push(Order(parameterHash, closingDate, leverage, msg.sender, paymentAddress, msg.value));
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

        // Fail the call if there's no more than 1 open order
        require(openOrderHashes.length > 1);

        for (uint i = 0; i < openOrderHashes.length; i++) {
            // Check that both sides have open orders with same parameters
            if (longs[paramHash].length > 0 && shorts[paramHash].length > 0) {

                bytes32 paramHash = openOrderHashes[i];
                uint256 amountLong = 0;
                uint256 amountShort = 0;

                // Calculate the amount of wei in long orders
                for (uint j = 0; j < longs[paramHash].length; j++) {
                    amountLong.add(longs[paramHash][j].balance);
                }

                // Calculate the amount of wei in short orders
                for (uint k = 0; k < shorts[paramHash].length; k++) {
                    if (amountShort < amountLong) {
                        uint256 longShortDiff = amountShort.sub(amountLong);
                        if (shorts[paramHash][k].balance > longShortDiff) {
                            amountShort.add(shorts[paramHash][k].balance);
                        } else {
                            amountShort.add(shorts[paramHash][k].balance);
                        }
                    }
                }

                uint256 amountForHash = amountLong.add(amountShort);
                uint256 feeForHash = amountForHash.mul(uint256(3).div(uint256(10)));
                amountForHash = amountForHash.sub(feeForHash);

                feeWallet.transfer(feeForHash);
            }
        }
    }
    
    // Spawns a new option contract
    /* function createController(Order[] longOrders, Order[] shortOrders) public {
        var initialOrder = longOrders[0];
        address newController = new LongShortController(initialOrder.parameterHash, initialOrder.closingDate, initialOrder.leverage, longOrders, shortOrders);
        controllers.push(newController);
    } */
}
