pragma solidity ^0.4.18;

/**
@title Debuggable
@dev Contract that's meant to be extended in other contracts to give them
a debug event to test the code with. Just import, "SampleContract is Debuggable"
and then in the SampleContract, writing debug("event") will write an event in the blockchain.

@author Convoluted Labs
*/
contract Debuggable {

  /**
  @dev String debugger
  @param message string that's written in the blockchain
  */
  event DebugString(string message);

  /**
  @dev String with value debugger
  @param message string that's written in the blockchain
  @param value uint that's written in the blockchain
  */
  event DebugWithValue(string message, uint value);

  /**
  @dev Debug a string
  @param message
  */
  function debugString(string message) public {
    DebugString(message);
  }

  /**
  @dev Debug a string with a value
  @param message
  @param value
  */
  function debugWithValue(string message, uint value) public {
    DebugWithValue(message, value);
  }

}
