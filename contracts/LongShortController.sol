pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";
import "./SafeMath.sol";

/**
 * Controller for a single Long/Short option
 * on the Ethereum blockchain. Spawned by
 * OrdersManager.
 */
contract LongShortController is Ownable, Debuggable {
    
    // Use Zeppelin's SafeMath library for calculations
    using SafeMath for uint256;

    uint[] private activeClosingDates;
    mapping(uint => LongShort[]) private longShorts;

    /**
     * Order struct
     * Constructed in OrdersManager
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
     * Activated LongShort struct
     */
    struct LongShort {
        uint startingDate;
        uint closingDate;
        uint leverage;
        Order[] longs;
        Order[] shorts;
    }

    /**
     * LongShort activator function. Called by OrdersManager.
     */
    /* function openLongShort(Order[] longs, Order[] shorts) external payable onlyOwner {
        uint memory closingDate = longs[0].closingDate;
        uint memory leverage = longs[0].leverage;
        longShorts.push(LongShort(block.timestamp, closingDate, leverage, longs, shorts));
    } */

    function getActiveClosingDates() public view returns (uint[]) {
        return activeClosingDates;
    }

    function checkConstructor() public view returns (bytes32) {
        return keccak256(owner);
    }
}
