pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";
import "./Validatable.sol";
import "./SafeMath.sol";
import "./Oracle.sol";

/**
@dev Controller for Long/Short options
on the Ethereum blockchain.

@author Convoluted Labs
*/
contract LongShortController is Ownable, Debuggable, Validatable {

    // Use Zeppelin's SafeMath library for calculations
    using SafeMath for uint256;

    /**
    @dev Position struct
    */
    struct Position {
        bool isLong;
        bytes32 ownerSignature;
        address paymentAddress;
        uint256 balance;
    }

    /**
    @dev Activated LongShort struct
    */
    struct LongShort {
        string currencyPair;
        uint256 startingPrice;
        uint closingDate;
        uint8 leverage;
    }

    /**
    @dev Reward struct for calculated rewards
    */
    struct Reward {
        address paymentAddress;
        uint256 balance;
    }

    /// List of active closing dates
    uint[] public activeClosingDates;
    mapping(uint => bytes32[]) private longShortHashes;
    mapping(bytes32 => LongShort) private longShorts;
    mapping(bytes32 => Position[]) private positions;

    // Queued rewards
    Reward[] private rewards;

    Oracle public oracle;
    address public oracleAddress;

    /**
    @dev Links Vanilla's oracle to the contract
    */
    function linkOracle(address _oracleAddress) public onlyOwner {
        oracleAddress = _oracleAddress;
        oracle = Oracle(oracleAddress);
        debug("Oracle linked");
    }

    /**
    @dev LongShort activator function. Called by OrdersManager.
    */
    function openLongShort(bytes32 parameterHash, string currencyPair, uint duration, uint8 leverage, bytes32[] ownerSignatures, address[] paymentAddresses, uint256[] balances, bool[] isLongs) public payable onlyOwner {
        /// Input validation
        require(ownerSignatures.length == paymentAddresses.length);
        require(paymentAddresses.length == balances.length);
        require(balances.length == isLongs.length);
        requireZeroSum(isLongs, balances);
        validateCurrencyPair(currencyPair);
        validateLeverage(leverage);

        uint256 startingPrice = 900; // CHange this to an oracle-fetched price
        bytes32 longShortHash = keccak256(this, parameterHash, block.timestamp);
        uint closingDate = block.timestamp.add(duration);

        for (uint8 i = 0; i < isLongs.length; i++) {
            positions[longShortHash].push(Position(isLongs[i], ownerSignatures[i], paymentAddresses[i], balances[i]));
        }

        activeClosingDates.push(closingDate);
        longShortHashes[closingDate].push(longShortHash);
        longShorts[longShortHash] = LongShort(currencyPair, startingPrice, closingDate, leverage);

        debug("New LongShort activated.");
    }

    function getLongShortHashes(uint closingDate) public view onlyOwner returns (bytes32[]) {
        return longShortHashes[closingDate];
    }

    function getLongShort(bytes32 longShortHash) public view onlyOwner returns (string, uint256, uint8) {
        return (longShorts[longShortHash].currencyPair, longShorts[longShortHash].startingPrice, longShorts[longShortHash].leverage);
    }

    function calculateReward(bool isLong, uint256 balance, uint leverage, uint256 startingPrice, uint256 closingPrice) internal pure returns (uint256) {
        uint256 reward = 0;
        if (startingPrice > closingPrice) {

        }
        return reward;
    }

    function getRewardsLength() public view onlyOwner returns (uint) {
        return rewards.length;
    }

    function exercise(bytes32 longShortHash) public {
        LongShort memory longShort = longShorts[longShortHash];

        require(longShort.closingDate <= block.timestamp);
        debug("Given closingDate is over it's expiry.");

        uint positionsLength = positions[longShortHash].length;

        debug("Calculating rewards...");

        Position[] memory positionsForHash = positions[longShortHash];

        for (uint8 j = 0; j < positionsLength; j++) {
            rewards.push(
                Reward(
                    positionsForHash[j].paymentAddress,
                    calculateReward(
                        positionsForHash[j].isLong,
                        positionsForHash[j].balance,
                        longShort.leverage,
                        longShort.startingPrice,
                        oracle.latestPrice()
                    )
                )
            );
            delete positions[longShortHash];
            debug("New reward calculated, position ended");
        }

        delete longShorts[longShortHash];
    }

    function payRewards() public {
        for (uint8 paymentNum = 0; paymentNum < rewards.length; paymentNum++) {
            rewards[paymentNum].paymentAddress.transfer(rewards[paymentNum].balance);
            delete rewards[paymentNum];
            debug("Reward paid!");
        }
        rewards.length = 0;
    }
}
