pragma solidity ^0.4.18;

/**
 * Controller for a single Long/Short option
 * on the Ethereum blockchain. Spawned by
 * OrdersManager.
 */
contract LongShortController {
    uint public parameterSignature;
    uint private startingDate;
    uint private expirationDate;
    uint private startingPrice;
    uint private leverage;

    struct Order {
        uint parameterSignature;
        uint expirationDate;
        uint leverage;
        uint closingSignature;
        address originAddress;
        address paymentAddress;
        uint balance;
    }

    Order[] private shortOrders;
    Order[] private longOrders;

    function LongShortController(uint paramSig, uint expDate, uint lvrg, Order[] l, Order[] s) public {
        startingDate = block.timestamp;
        parameterSignature = paramSig;
        expirationDate = expDate;
        leverage = lvrg;
        longOrders = l;
        shortOrders = s;
    }
}
