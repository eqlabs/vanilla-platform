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
    mapping(bytes32 => Position[]) private positions;

    /**
     * Position struct
     */
    struct Position {
        bool isLong;
        bytes32 ownerSignature;
        address paymentAddress;
        uint256 balance;
    }

    /**
     * Activated LongShort struct
     */
    struct LongShort {
        bytes32 parameterHash;
        uint startingDate;
        uint256 startingPrice;
        uint leverage;
    }

    /**
     * LongShort activator function. Called by OrdersManager.
     */
    function openLongShort(bytes32 parameterHash, uint closingDate, uint leverage, bytes32[] ownerSignatures, address[] paymentAddresses, uint256[] balances, bool[] isLongs) public payable onlyOwner {

        uint256 startingPrice = 900; // CHange this to an oracle-fetched price
        bytes32 longShortHash = keccak256(this, parameterHash, block.timestamp);

        for (uint8 i = 0; i < isLongs.length; i++) {
            positions[longShortHash].push(Position(isLongs[i], ownerSignatures[i], paymentAddresses[i], balances[i]));
        }

        activeClosingDates.push(closingDate);
        longShorts[closingDate].push(LongShort(parameterHash, block.timestamp, startingPrice, leverage));

        debug("New LongShort activated.");
    }

    function getActiveClosingDates() public view returns (uint[]) {
        return activeClosingDates;
    }
}
