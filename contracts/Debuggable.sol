pragma solidity ^0.4.18;

contract Debuggable {
  event DebugEvent(string message);
  function debug(string message) public {
    DebugEvent(message);
  }
}
