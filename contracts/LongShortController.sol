pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Validatable.sol";
import "./SafeMath.sol";
import "./Oracle.sol";

/**
@dev Controller for Long/Short options
on the Ethereum blockchain.

@author Convoluted Labs
*/
contract LongShortController is Ownable, Validatable {

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
        bytes7 currencyPair;
        uint256 startingPrice;
        uint closingDate;
        uint8 leverage;
    }

    /// List of active closing dates
    uint[] public activeClosingDates;
    mapping(uint => bytes32[]) private longShortHashes;
    mapping(bytes32 => LongShort) private longShorts;
    mapping(bytes32 => Position[]) private positions;

    /// Queued rewards
    address[] private rewardableAddresses;
    mapping(address => uint256) private rewards;

    /// Price oracle contract and address
    Oracle public oracle;
    address public oracleAddress;

    /**
    @dev Links Vanilla's oracle to the contract
    @param _oracleAddress The address of the deployed oracle contract
    */
    function linkOracle(address _oracleAddress) public onlyOwner {
        oracleAddress = _oracleAddress;
        oracle = Oracle(oracleAddress);
    }

    /**
    @dev LongShort opener function. Can only be called by the owner.
    @param parameterHash Hash of the parameters, used in creating the unique LongShortHash
    @param currencyPair A 7-character representation of a currency pair
    @param duration seconds to closing date from block.timestamp
    @param leverage A modifier which defines the rewards and the allowed price jump
    @param ownerSignatures A list of bytes32 signatures for position owners
    @param paymentAddresses A list of addresses to be rewarded
    @param balances A list of original bet amounts
    @param isLongs A list of position types {true: "LONG", false: "SHORT"}
    */
    function openLongShort(bytes32 parameterHash, bytes7 currencyPair, uint duration, uint8 leverage, bytes32[] ownerSignatures, address[] paymentAddresses, uint256[] balances, bool[] isLongs) public payable onlyOwner {
        /// Input validation
        require(ownerSignatures.length == paymentAddresses.length);
        require(paymentAddresses.length == balances.length);
        require(balances.length == isLongs.length);
        requireZeroSum(isLongs, balances);
        validateLeverage(leverage);

        /// Get latest price for the currency pair from the Oracle
        uint256 startingPrice = oracle.price(currencyPair);

        /// Require that the Oracle has price information of the currency pair
        require(startingPrice > 0);

        /// Make a unique identifier for the LongShort in question
        bytes32 longShortHash = keccak256(this, parameterHash, block.timestamp);

        /// Add the duration to the current block timestamp to create a closing date
        uint closingDate = block.timestamp.add(duration);

        /// Add positions to the LongShort
        for (uint i = 0; i < isLongs.length; i++) {
            positions[longShortHash].push(Position(isLongs[i], ownerSignatures[i], paymentAddresses[i], balances[i]));
        }

        /// Add knowledge of the new LongShort to the blockchain
        activeClosingDates.push(closingDate);
        longShortHashes[closingDate].push(longShortHash);
        longShorts[longShortHash] = LongShort(currencyPair, startingPrice, closingDate, leverage);
    }

    /**
    @dev Calculates reward for a single position with given parameters
    @param isLong {true: "LONG", false: "SHORT"}
    @param balance the balance to calculate a reward for
    @param leverage leverage of the LongShort
    @param startingPrice price fetched from the Oracle on creation
    @param closingPrice price fetched from the Oracle when this function was called
    @return {
        "reward": "Reward that is added to a payment pool"
    }
    */
    function calculateReward(bool isLong, uint256 balance, uint8 leverage, uint256 startingPrice, uint256 closingPrice) public pure returns (uint256 reward) {
        uint256 priceDiff = startingPrice > closingPrice ? startingPrice.sub(closingPrice) : closingPrice.sub(startingPrice);
        uint256 diffPercentage = priceDiff.mul(10000).mul(leverage).div(startingPrice);
        uint256 balanceDiff = balance.mul(diffPercentage).div(10000);
        if (balanceDiff > balance) {
            balanceDiff = balance;
        }
        if (startingPrice > closingPrice && isLong || startingPrice <= closingPrice && !isLong) {
            reward = balance.sub(balanceDiff);
        } else {
            reward = balance.add(balanceDiff);
        }
        return reward;
    }

    /**
    @dev Removes longshorts from storage
    @param longShortHash identifier of the LongShort to be removed
    @param closingDate the latest date the LongShort should close
    */
    function unlinkLongShortFromClosingDate(bytes32 longShortHash, uint closingDate) internal {
        for (uint i = 0; i < activeClosingDates.length; i++) {
            if (activeClosingDates[i] == closingDate) {
                bytes32[] storage hashes = longShortHashes[closingDate];
                for (uint j = 0; j < hashes.length; j++) {
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
    @dev Function to ping a single LongShort with
    Checks if the price has increased or decreased enough for a margin call.
    Exercises the option when it's closing date is over expiry.
    @param longShortHash the unique identifier of a LongShort
    */
    function ping(bytes32 longShortHash) public {
        /// Load the LongShort into memory
        LongShort memory longShort = longShorts[longShortHash];

        /// Get the latest price from the oracle
        uint256 latestPrice = oracle.price(longShort.currencyPair);

        /// Require that the Oracle has price information of the currency pair
        require(latestPrice > 0);

        /// Calculate the threshold for a margin call by
        /// dividing the starting price with the leverage
        uint256 diffThreshold = longShort.startingPrice.div(longShort.leverage);
        
        /// Calculate the price difference between latest price
        /// from the Oracle and the starting price of the LongShort
        uint256 priceDiff = longShort.startingPrice > latestPrice ? longShort.startingPrice.sub(latestPrice) : latestPrice.sub(longShort.startingPrice);

        /// Margin call
        if (priceDiff >= diffThreshold) {
            closeLongShort(longShortHash, latestPrice);
        }

        /// Option has expired
        if (longShort.closingDate <= block.timestamp) {
            closeLongShort(longShortHash, latestPrice);
        }
    }

    /**
    @dev Internal function to be called, when a ping causes expiry or a margin call
    @param longShortHash the unique identifier of a LongShort
    @param latestPrice the closing price of the LongShort
    */
    function closeLongShort(bytes32 longShortHash, uint256 latestPrice) internal {
        /// Load the LongShort into memory
        LongShort memory longShort = longShorts[longShortHash];
        
        /// Get the amount of positions in the LongShort for looping
        uint positionsLength = positions[longShortHash].length;

        /// Load the positions into memory
        Position[] memory positionsForHash = positions[longShortHash];

        /// Calculate and queue the rewards for each position,
        /// and remove the positions from the LongShort
        for (uint j = 0; j < positionsLength; j++) {
            rewardableAddresses.push(positionsForHash[j].paymentAddress);
            rewards[positionsForHash[j].paymentAddress] = rewards[positionsForHash[j].paymentAddress].add(calculateReward(
                        positionsForHash[j].isLong,
                        positionsForHash[j].balance,
                        longShort.leverage,
                        longShort.startingPrice,
                        latestPrice
                    ));
            delete positions[longShortHash];
        }

        /// Delete the LongShort from the blockchain
        delete longShorts[longShortHash];

        /// Unlink the LongShort from the closing date
        unlinkLongShortFromClosingDate(longShortHash, longShort.closingDate);
    }

    /**
    @dev Pays a reward to an address
    */
    function withdrawReward(address _paymentAddress) public {
        require(rewards[_paymentAddress] > 0);
        uint256 rewardBalance = rewards[_paymentAddress];
        delete rewards[_paymentAddress];
        for (uint i = 0; i < rewardableAddresses.length; i++) {
            if (rewardableAddresses[i]==_paymentAddress) {
                delete rewardableAddresses[i];
                break;
            }
        }
        rewardableAddresses.length--;
        _paymentAddress.transfer(rewardBalance);
    }


    // GETTERS

    /**
    @dev Get all queued rewardable addresses
    @return {
        "_rewardableAddresses": "rewardable addresses in queue"
    }
    */
    function getRewardableAddresses() public view onlyOwner returns (address[] _rewardableAddresses) {
        return rewardableAddresses;
    }

    /**
    @dev Gets all active closing dates from the contract

    @return {
        "closingDates": "List of seconds from 1970."
    }
    */
    function getActiveClosingDates() public view returns (uint[] closingDates) {
        return activeClosingDates;
    }

    /**
    @dev Get LongShort identifiers/hashes by closing date.
    Only callable by the owner.
    @param closingDate closing date to get LongShorts for
    @return {
        "hashes": "Unique identifiers for the LongShorts expiring on the closingDate."
    }
    */
    function getLongShortHashes(uint closingDate) public view onlyOwner returns (bytes32[] hashes) {
        return longShortHashes[closingDate];
    }

    /**
    @dev Get a single LongShort with its identifier
    Only callable by the owner.
    @param longShortHash unique identifier for a LongShort
    @return {
        "currencyPair": "7-character representation of a currency pair. For example, ETH-USD",
        "startingPrice": "self-explanatory",
        "leverage": "self-explanatory"
    }
    */
    function getLongShort(bytes32 longShortHash) public view onlyOwner returns (bytes32 currencyPair, uint256 startingPrice, uint8 leverage) {
        return (longShorts[longShortHash].currencyPair, longShorts[longShortHash].startingPrice, longShorts[longShortHash].leverage);
    }
}
