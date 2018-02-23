pragma solidity ^0.4.18;
import "./SafeMath.sol";

contract Validatable {
  // Use Zeppelin's SafeMath library for calculations
  using SafeMath for uint256;
  
  // Allowed leverages
  uint8[] public LEVERAGES = [ 2, 5 ];

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
