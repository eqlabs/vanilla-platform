pragma solidity ^0.4.18;

/**
 * @title Debuggable
 * @dev Contract that's meant to be extended in other contracts to give them
 * a debug event to test the code with. Just import, "SampleContract is Debuggable"
 * and then in the SampleContract, writing debug("event") will write an event in the blockchain.
 */
contract Debuggable {
  event DebugEvent(string message);
  function debug(string message) public {
    DebugEvent(message);
  }
}
