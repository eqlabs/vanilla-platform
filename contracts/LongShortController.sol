pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";
import "./SafeMath.sol";

/**
 * Controller for Long/Short options
 * on the Ethereum blockchain.
 *
 * @author Convoluted Labs
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
        uint256 startingPrice;
        uint leverage;
    }

    /**
     * LongShort activator function. Called by OrdersManager.
     */
    function openLongShort(bytes32 parameterHash, uint duration, uint leverage, bytes32[] ownerSignatures, address[] paymentAddresses, uint256[] balances, bool[] isLongs) public payable onlyOwner {

        // Require all input arrays to be the same length
        // The backend must make sure that the indices point to the same original order
        require(ownerSignatures.length == paymentAddresses.length);
        require(paymentAddresses.length == balances.length);
        require(balances.length == isLongs.length);

        uint256 startingPrice = 900; // CHange this to an oracle-fetched price
        bytes32 longShortHash = keccak256(this, parameterHash, block.timestamp);
        uint closingDate = block.timestamp + duration;

        for (uint8 i = 0; i < isLongs.length; i++) {
            positions[longShortHash].push(Position(isLongs[i], ownerSignatures[i], paymentAddresses[i], balances[i]));
        }

        activeClosingDates.push(closingDate);
        longShorts[closingDate].push(LongShort(parameterHash, startingPrice, leverage));

        debug("New LongShort activated.");

    }

    function getActiveClosingDates() public view returns (uint[]) {
        return activeClosingDates;
    }
}
