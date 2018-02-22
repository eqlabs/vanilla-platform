pragma solidity ^0.4.18;
import "./SafeMath.sol";

contract Validatable {
  // Use Zeppelin's SafeMath library for calculations
  using SafeMath for uint256;

  // Allowed order types
  string[] public POSITION_TYPES = [ "LONG", "SHORT" ];

  // Allowed currency pairs
  string[] public CURRENCY_PAIRS = [ "ETH-USD", "BTC-USD" ];

  // Allowed leverages
  uint8[] public LEVERAGES = [ 2, 5 ];

  /**
  @dev A function that compares two strings for equality.
  Hashes first and second with keccak256 and checks if the hashes are equal.
  */
  function stringsAreEqual(string first, string second) internal pure returns (bool) {
      return keccak256(first) == keccak256(second);
  }

  function validateCurrencyPair(string currencyPair) public view {
    // Check currencyPair against allowed pairs
    bool allowedPair = false;
    for (uint8 i = 0; i < CURRENCY_PAIRS.length; i++) {
        if (stringsAreEqual(currencyPair, CURRENCY_PAIRS[i])) {
            allowedPair = true;
            break;
        }
    }
    require(allowedPair);
  }

  function validatePositionType(string positionType) public view {
    // Check positionType against allowed types
    bool allowedPosition = false;
    for (uint8 i = 0; i < POSITION_TYPES.length; i++) {
        if (stringsAreEqual(positionType, POSITION_TYPES[i])) {
            allowedPosition = true;
            break;
        }
    }
    require(allowedPosition);
  }

  function validateLeverage(uint8 leverage) public view {
    // Check leverage against allowed amounts
    bool allowedLeverage = false;
    for (uint8 i = 0; i < LEVERAGES.length; i++) {
        if (leverage == LEVERAGES[i]) {
            allowedLeverage = true;
            break;
        }
    }
    require(allowedLeverage);
  }

  function validateAllParameters(string currencyPair, string positionType, uint8 leverage) public view {
    validateCurrencyPair(currencyPair);
    validatePositionType(positionType);
    validateLeverage(leverage);
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
      require(shortBalance==longBalance);
  }
}
