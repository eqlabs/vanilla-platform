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
        bytes32 currencyPair;
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

    // Price oracle contract and address
    Oracle public oracle;
    address public oracleAddress;

    /**
    @dev Links Vanilla's oracle to the contract
    */
    function linkOracle(address _oracleAddress) public onlyOwner {
        oracleAddress = _oracleAddress;
        oracle = Oracle(oracleAddress);
        debugString("Oracle linked");
    }

    /**
    @dev LongShort opener function. Can only be called by the owner.
    */
    function openLongShort(bytes32 parameterHash, bytes32 currencyPair, uint duration, uint8 leverage, bytes32[] ownerSignatures, address[] paymentAddresses, uint256[] balances, bool[] isLongs) public payable onlyOwner {
        /// Input validation
        require(ownerSignatures.length == paymentAddresses.length);
        require(paymentAddresses.length == balances.length);
        require(balances.length == isLongs.length);
        requireZeroSum(isLongs, balances);
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

        debugString("New LongShort activated.");
    }

    /**
    @dev Gets all active closing dates from the contract

    @return {
        "closingDates": "uint[]"
    }
    */
    function getActiveClosingDates() public view returns (uint[] closingDates) {
        return activeClosingDates;
    }

    /**
    @dev Get LongShort identifiers/hashes by closing date.
    Only callable by the owner.

    @param closingDate (uint)
    @return {
        "hashes": "bytes32[]"
    }
    */
    function getLongShortHashes(uint closingDate) public view onlyOwner returns (bytes32[] hashes) {
        return longShortHashes[closingDate];
    }

    /**
    @dev Get a single LongShort with its identifier
    Only callable by the owner.

    @param longShortHash (bytes32)
    @return {
        "currencyPair": "bytes32[]",
        "startingPrice": "uint256",
        "leverage": "uint8"
    }
    */
    function getLongShort(bytes32 longShortHash) public view onlyOwner returns (bytes32 currencyPair, uint256 startingPrice, uint8 leverage) {
        return (longShorts[longShortHash].currencyPair, longShorts[longShortHash].startingPrice, longShorts[longShortHash].leverage);
    }

    /**
    @dev Calculates reward for a single position with given parameters

    @param isLong boolean { true: "LONG", false: "SHORT" }
    @param balance the original stake of the user (uint256)
    @param leverage the leverage of the LongShort (uint8)
    @param startingPrice (uint256)
    @param closingPrice (uint256)
    @return {
        "reward": "uint256"
    }
    */
    function calculateReward(bool isLong, uint256 balance, uint8 leverage, uint256 startingPrice, uint256 closingPrice) public pure returns (uint256 reward) {
        uint256 priceDiff;
        uint256 balanceDiff;
        uint256 diffPercentage;

        if (startingPrice > closingPrice) {

            priceDiff = startingPrice.sub(closingPrice);
            diffPercentage = priceDiff.mul(100).mul(leverage).div(startingPrice);
            balanceDiff = balance.mul(diffPercentage).div(100);

            if (balanceDiff > balance) {
                balanceDiff = balance;
            }

            if (isLong) {
                reward = balance.sub(balanceDiff);
            } else {
                reward = balance.add(balanceDiff);
            }

        } else {

            priceDiff = closingPrice.sub(startingPrice);
            diffPercentage = priceDiff.mul(100).mul(leverage).div(startingPrice);
            balanceDiff = balance.mul(diffPercentage).div(100);

            if (balanceDiff > balance) {
                balanceDiff = balance;
            }

            if (isLong) {
                reward = balance.add(balanceDiff);
            } else {
                reward = balance.sub(balanceDiff);
            }

        }

        return reward;
    }

    /**
    @dev Get the length of all queued rewards
    @return {
        "rewardsLength": "uint"
    }
    */
    function getRewardsLength() public view onlyOwner returns (uint rewardsLength) {
        return rewards.length;
    }

    function unlinkLongShortFromClosingDate(bytes32 longShortHash, uint closingDate) internal {
        for (uint8 i = 0; i < activeClosingDates.length; i++) {
            if (activeClosingDates[i] == closingDate) {
                bytes32[] storage hashes = longShortHashes[closingDate];
                for (uint8 j = 0; j < hashes.length; j++) {
                    if (hashes[j] == longShortHash) {
                        delete hashes[j];
                        hashes.length--;
                        if (hashes.length == 0) {
                            delete activeClosingDates[i];
                            activeClosingDates.length--;
                        } else {
                            longShortHashes[closingDate] = hashes;
                        }
                        break;
                    }
                }
                break;
            }
        }
    }


    /**
    @dev A function that exercises an option on it's expiry,
    effectively calculating rewards and closing positions

    @param longShortHash the unique ID for a single LongShort
    */
    function exercise(bytes32 longShortHash) public {
        LongShort memory longShort = longShorts[longShortHash];

        require(longShort.closingDate <= block.timestamp);
        debugString("Given closingDate is over it's expiry.");

        uint positionsLength = positions[longShortHash].length;

        debugString("Calculating rewards...");

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
            debugString("New reward calculated, position ended");
        }

        delete longShorts[longShortHash];
        unlinkLongShortFromClosingDate(longShortHash, longShort.closingDate);
    }

    /**
    @dev Pays all queued rewards to their corresponding addresses
    */
    function payRewards() public {
        for (uint8 paymentNum = 0; paymentNum < rewards.length; paymentNum++) {
            rewards[paymentNum].paymentAddress.transfer(rewards[paymentNum].balance);
            delete rewards[paymentNum];
            debugString("Reward paid!");
        }
        rewards.length = 0;
    }
}
