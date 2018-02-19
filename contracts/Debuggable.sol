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
  @dev The triggerable debug event
  @param message string that's written in the blockchain
  */
  event DebugEvent(string message);

  /**
  @dev Debug function that gets injected to extending contracts
  @param message the message that we want to log/debug
  */
  function debug(string message) public {
    DebugEvent(message);
  }

}
