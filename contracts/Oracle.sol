pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";

contract Oracle is Ownable, Debuggable {
  uint[] public timesUpdated;
  mapping(uint => uint) public priceByTime;
  uint public latestPrice;

  function Oracle(uint _startingPrice) public {
    timesUpdated.push(block.timestamp);
    priceByTime[block.timestamp] = _startingPrice;
    latestPrice = _startingPrice;
  }
  
  function setLatestPrice(uint _latestPrice) public onlyOwner {
    timesUpdated.push(block.timestamp);
    priceByTime[block.timestamp] = _latestPrice;
    latestPrice = _latestPrice;
    debug("Oracle price updated!");
  }
}
