// eslint-disable-next-line
const OrdersManager = artifacts.require("../contracts/OrdersManager.sol");
// eslint-disable-next-line
const { should, BigNumber } = require("./helpers");

async function createLongOrder(
  instance,
  orderID,
  duration,
  leverage,
  sender,
  position
) {
  return await instance.createOrder(
    orderID,
    "ETH-USD",
    "LONG",
    duration,
    leverage,
    sender,
    {
      from: sender,
      value: position
    }
  );
}

async function createShortOrder(
  instance,
  orderID,
  duration,
  leverage,
  sender,
  position
) {
  return await instance.createOrder(
    orderID,
    "ETH-USD",
    "SHORT",
    duration,
    leverage,
    sender,
    {
      from: sender,
      value: position
    }
  );
}

// eslint-disable-next-line
contract("OrdersManager", ([owner, user, feeWallet]) => {
  let instance, minimumPosition, maximumPosition;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await OrdersManager.new(owner);
      minimumPosition = await instance.MINIMUM_POSITION.call();
      minimumPosition = new BigNumber(minimumPosition);
      maximumPosition = await instance.MAXIMUM_POSITION.call();
      maximumPosition = new BigNumber(maximumPosition);
      //eslint-disable-next-line
      //gasLimit = await web3.eth.estimateGas();
    }
  );

  it("Should set owner as owner", async () => {
    const contract_owner = await instance.owner.call();
    contract_owner.should.equal(owner);
  });

  it("Should be able to set the fee wallet when owner", async () => {
    try {
      await instance.setFeeWallet(feeWallet, {
        from: owner
      });
      return true;
    } catch (e) {
      e.should.not.exist;
    }
  });

  it("Should not be able to set the fee wallet by anyone but the owner", async () => {
    await instance
      .setFeeWallet(feeWallet, {
        from: owner
      })
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should be able to create a new short order with minimum position", async () => {
    await createShortOrder(instance, "ebin", 14, 2, user, minimumPosition);
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(minimumPosition);
  });

  it("Should be able to create a new long order with minimum position", async () => {
    await createLongOrder(instance, "ebin", 14, 2, user, minimumPosition);
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(minimumPosition);
  });

  it("Should not be able to create a new long order with under minimum position", async () => {
    await createLongOrder(
      instance,
      "ebin",
      14,
      2,
      user,
      minimumPosition.sub(10)
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to create a new short order with under minimum position", async () => {
    await createShortOrder(
      instance,
      "ebin",
      14,
      2,
      user,
      minimumPosition.sub(10)
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to create a new long order with over maximum position", async () => {
    await createLongOrder(
      instance,
      "ebin",
      14,
      2,
      user,
      maximumPosition.add(10)
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to create a new short order with over maximum position", async () => {
    await createShortOrder(
      instance,
      "ebin",
      14,
      2,
      user,
      maximumPosition.add(10)
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to create a new order with an unsupported leverage", async () => {
    await instance
      .createOrder("ebin", "ETH-USD", "SHORT", 14, 500, user, {
        from: user,
        value: minimumPosition
      })
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to create duplicate orders", async () => {
    await createShortOrder(instance, "ebin", 14, 2, user, minimumPosition);
    await createShortOrder(instance, "ebin", 14, 2, user, minimumPosition)
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to delete order when balance is over 0", async () => {
    await createShortOrder(instance, "asdlol", 14, 2, user, minimumPosition);
    const paramHashes = await instance.getOpenParameterHashes({
      from: owner
    });
    const openOrders = await instance.getOpenOrderIDs(paramHashes[0], {
      from: owner
    });
    const order = await instance.getOrder(openOrders[0], {
      from: owner
    });
    order[4].should.be.bignumber.gt(0);
    await instance
      .deleteOrder(openOrders[0], {
        from: owner
      })
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should be able to delete order when balance is 0", async () => {
    await createShortOrder(instance, "asdlol", 14, 2, user, minimumPosition);
    const paramHashes = await instance.getOpenParameterHashes({
      from: owner
    });
    const openOrders = await instance.getOpenOrderIDs(paramHashes[0], {
      from: owner
    });
    const order = await instance.getOrder(openOrders[0], {
      from: owner
    });
    order[4].should.be.bignumber.gt(0);
    await instance.updateOrderBalance(openOrders[0], 0, {
      from: owner
    });
    await instance.deleteOrder(openOrders[0], {
      from: owner
    });
    const deletedOrder = await instance.getOrder(openOrders[0], {
      from: owner
    });
    deletedOrder[4].should.be.bignumber.equal(0);
  });

  it("Should be able to pay fees to the fee wallet", async () => {
    await instance.setFeeWallet(feeWallet, {
      from: owner
    });
    //eslint-disable-next-line
    const initialBalance = await web3.eth.getBalance(feeWallet);
    await instance.createOrder("ebin", "ETH-USD", "SHORT", 14, 2, user, {
      from: user,
      value: minimumPosition
    });
    await instance.createOrder("ebinings", "ETH-USD", "LONG", 14, 2, owner, {
      from: owner,
      value: minimumPosition
    });
    await instance.withdrawFee({
      from: owner
    });
    //eslint-disable-next-line
    const feeWalletBalance = await web3.eth.getBalance(feeWallet);
    feeWalletBalance.should.be.bignumber.equal(
      initialBalance.add(
        minimumPosition
          .add(minimumPosition)
          .mul(3)
          .div(100)
      )
    );
  });
});
