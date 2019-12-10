pragma solidity ^0.4.26;
import "./Ownable.sol";

/**
@title Debuggable
@dev Contract that's meant to be extended in other contracts to give them
a debug event to test the code with. Just import, "SampleContract is Debuggable"
and then in the SampleContract, writing debug("event") will write an event in the blockchain.

@author Convoluted Labs
*/
contract Debuggable is Ownable {

  bool enabled = false;

  /**
  @dev String debugger
  */
  event DebugString(string message);

  /**
  @dev String with value debugger
  */
  event DebugWithValue(string message, uint value);

  /**
  @dev Debug a string
  */
  function debugString(string message) public {
    if (enabled) {
      emit DebugString(message);
    }
  }

  /**
  @dev Debug a string with a value
  */
  function debugWithValue(string message, uint value) public {
    if (enabled) {
      emit DebugWithValue(message, value);
    }
  }

  /**
  @dev activates or deactivates the debug functionality.
  */
  function toggleDebug() public onlyOwner {
    enabled = !enabled;
  }

}
