pragma solidity ^0.4.26;
import "./SafeMath.sol";

/**
@dev Contract that handles constants between
the Vanilla platform contracts.
*/
contract Validatable {
    // Use Zeppelin's SafeMath library for calculations
    using SafeMath for uint256;

    // Allowed leverages
    uint8[] public LEVERAGES = [ 2, 5 ];

    /**
    @dev Helper function to restrict users from opening orders
    with any other than predefined leverages.

    @param leverage an uint8 number
    */
    function validateLeverage(uint8 leverage) public view {
        // Check leverage against allowed amounts
        bool allowedLeverage = false;
        for (uint8 i = 0; i < LEVERAGES.length; i++) {
            if (leverage == LEVERAGES[i]) {
                allowedLeverage = true;
                break;
            }
        }
        require(allowedLeverage, "Given leverage not allowed!");
    }

    /**
    @dev Helper function to check if both sides of the bet have same balance

    @param isLongs list of position types in boolean [true, false]
    @param balances list of position amounts in wei
    */
    function requireZeroSum(bool[] isLongs, uint256[] balances) public pure {
        uint256 shortBalance;
        uint256 longBalance;
        for (uint8 i = 0; i < isLongs.length; i++) {
            if (isLongs[i]) {
                longBalance = longBalance.add(balances[i]);
            } else {
                shortBalance = shortBalance.add(balances[i]);
            }
        }
        require(shortBalance==longBalance, "Zero sum requirement not fulfilled!");
    }
}
