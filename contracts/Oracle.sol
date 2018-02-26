pragma solidity ^0.4.18;
import "./Ownable.sol";
import "./Debuggable.sol";

/**
@title Oracle
@dev A contract which saves price history to the Ethereum blockchain.

@author Convoluted Labs
*/
contract Oracle is Ownable, Debuggable {

  /// Array that contains the timestamps that the prices were updated
  uint[] public timesUpdated;

  /// Mapping that maps timestamps to a price
  mapping(uint => uint) public priceByTime;

  /// Single value, the latest price
  uint public latestPrice;

  /**
  @dev Oracle constructor.
  @param _startingPrice The genesis price for the instrument
  */
  function Oracle(uint _startingPrice) public {
    timesUpdated.push(block.timestamp);
    priceByTime[block.timestamp] = _startingPrice;
    latestPrice = _startingPrice;
  }
  
  /**
  @dev Endpoint for the Oracle owner to update prices
  @param _latestPrice The latest price from Vanilla API
  */
  function setLatestPrice(uint _latestPrice) public onlyOwner {
    timesUpdated.push(block.timestamp);
    priceByTime[block.timestamp] = _latestPrice;
    latestPrice = _latestPrice;
    debugString("Oracle price updated!");
  }
}
