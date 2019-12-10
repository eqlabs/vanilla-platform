pragma solidity ^0.4.26;
import "./Ownable.sol";

/**
@title Oracle
@dev A contract which saves price history to the Ethereum blockchain.

@author Convoluted Labs
*/
contract Oracle is Ownable {

    // Struct to use in pricesByTime
    struct Price {
        bytes7 currencyPair;
        uint256 price;
    }

    /// Array that contains the timestamps that the prices were updated
    uint[] public timesUpdated;

    /// Mapping that maps timestamps to a price
    mapping(uint => Price[]) public pricesByTime;

    /// Mapping of prices by currency pair
    mapping(bytes7 => uint256) public price;

    /**
    @dev Endpoint for the Oracle owner to update prices
    */
    function setLatestPrices(bytes7[] _currencyPairs, uint256[] _prices) public onlyOwner {
        require(_currencyPairs.length == _prices.length);
        timesUpdated.push(block.timestamp);
        for (uint i = 0; i < _currencyPairs.length; i++) {
            price[_currencyPairs[i]] = _prices[i];
            pricesByTime[block.timestamp].push(Price(_currencyPairs[i], _prices[i]));
        }
    }
}
