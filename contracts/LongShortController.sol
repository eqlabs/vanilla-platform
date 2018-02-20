pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";
import "./SafeMath.sol";
import "./Oracle.sol";

/**
@dev Controller for Long/Short options
on the Ethereum blockchain.

@author Convoluted Labs
*/
contract LongShortController is Ownable, Debuggable {

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
        bytes32 longShortHash;
        uint256 startingPrice;
        uint leverage;
    }

    /**
    @dev Payment struct for calculated payments
    */
    struct Payment {
        address paymentAddress;
        uint256 balance;
    }

    uint[] private activeClosingDates;
    Payment[] private payments;
    mapping(uint => LongShort[]) private longShorts;
    mapping(bytes32 => Position[]) private positions;

    Oracle public oracle;
    address public oracleAddress;

    function linkOracle(address _oracleAddress) public onlyOwner {
        oracleAddress = _oracleAddress;
        oracle = Oracle(oracleAddress);
        debug("Oracle linked");
    }

    /**
    @dev Helper function to check if both sides of the bet have same balance
    
    @param isLongs list of position types {long: true, short: false}
    @param balances list of position amounts in wei
    */
    function requireNullSum(bool[] isLongs, uint256[] balances) internal pure {
        uint256 shortBalance;
        uint256 longBalance;
        for (uint8 i = 0; i < isLongs.length; i++) {
            if (isLongs[i]) {
                longBalance = longBalance.add(balances[i]);
            } else {
                shortBalance = shortBalance.add(balances[i]);
            }
        }
        require(shortBalance==longBalance);
    }

    /**
    @dev LongShort activator function. Called by OrdersManager.
    */
    function openLongShort(bytes32 parameterHash, uint duration, uint leverage, bytes32[] ownerSignatures, address[] paymentAddresses, uint256[] balances, bool[] isLongs) public payable onlyOwner {

        // Require all input arrays to be the same length
        // The backend must make sure that the indices point to the same original order
        require(ownerSignatures.length == paymentAddresses.length);
        require(paymentAddresses.length == balances.length);
        require(balances.length == isLongs.length);

        // Require both sides of the LongShort to have same total balance
        requireNullSum(isLongs, balances);

        uint256 startingPrice = 900; // CHange this to an oracle-fetched price
        bytes32 longShortHash = keccak256(this, parameterHash, block.timestamp);
        uint closingDate = block.timestamp + duration;

        for (uint8 i = 0; i < isLongs.length; i++) {
            positions[longShortHash].push(Position(isLongs[i], ownerSignatures[i], paymentAddresses[i], balances[i]));
        }

        activeClosingDates.push(closingDate);
        longShorts[closingDate].push(LongShort(longShortHash, startingPrice, leverage));

        debug("New LongShort activated.");

    }

    function getActiveClosingDates() public view returns (uint[]) {
        return activeClosingDates;
    }

    function calculateReward(uint256 balance/* , uint leverage, uint256 startingPrice, uint256 closingPrice */) internal pure returns (uint256) {
        return balance;
    }

    function getPaymentsLength() public view onlyOwner returns (uint) {
        return payments.length;
    }

    function exercise(uint closingDate) public {
        require(closingDate <= block.timestamp);
        debug("Given closingDate is over it's expiry.");

        LongShort[] memory longShortsForDate = longShorts[closingDate];
        
        require(longShortsForDate.length > 0);

        for (uint8 i = 0; i < longShortsForDate.length; i++) {

            LongShort memory longShort = longShortsForDate[i];
            uint positionsLength = positions[longShort.longShortHash].length;

            debug("Calculating payments...");

            for (uint8 j = 0; j < positionsLength; j++) {
                payments.push(
                    Payment(
                        positions[longShort.longShortHash][j].paymentAddress,
                        calculateReward(
                            positions[longShort.longShortHash][j].balance/* ,
                            longShort.leverage,
                            longShort.startingPrice,
                            oracle.latestPrice() */
                        )
                    )
                );
                delete positions[longShort.longShortHash][j];
                debug("New reward calculated, position ended");
            }
        }
    }
}
