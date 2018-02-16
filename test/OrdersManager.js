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
  position,
  gasLimit
) {
  await instance.createOrder(orderID, duration, leverage, true, sender, {
    from: sender,
    value: position,
    gasLimit: gasLimit
  });
}

async function createShortOrder(
  instance,
  orderID,
  duration,
  leverage,
  sender,
  position,
  gasLimit
) {
  await instance.createOrder(orderID, duration, leverage, false, sender, {
    from: sender,
    value: position,
    gasLimit: gasLimit
  });
}

// eslint-disable-next-line
contract("OrdersManager", ([owner, user, feeWallet]) => {
  let instance, minimumPosition, maximumPosition;
  let gasLimit = 0xfffffffffff;

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
        from: owner,
        gasLimit: gasLimit
      });
      return true;
    } catch (e) {
      return false;
    }
  });

  it("Should not be able to set the fee wallet by anyone but the owner", async () => {
    try {
      await instance.setFeeWallet(feeWallet, {
        from: owner,
        gasLimit: gasLimit
      });
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should be able to create a new short order with minimum position", async () => {
    await createShortOrder(
      instance,
      "ebin",
      14,
      2,
      user,
      minimumPosition,
      gasLimit
    );
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(minimumPosition);
  });

  it("Should be able to create a new long order with minimum position", async () => {
    await createLongOrder(
      instance,
      "ebin",
      14,
      2,
      user,
      minimumPosition,
      gasLimit
    );
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(minimumPosition);
  });

  it("Should not be able to create a new long order with under minimum position", async () => {
    try {
      await createLongOrder(
        instance,
        "ebin",
        14,
        2,
        user,
        minimumPosition - 1,
        gasLimit
      );
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should not be able to create a new short order with under minimum position", async () => {
    try {
      await createShortOrder(
        instance,
        "ebin",
        14,
        2,
        user,
        minimumPosition - 1,
        gasLimit
      );
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should not be able to create a new long order with over maximum position", async () => {
    try {
      await createLongOrder(
        instance,
        "ebin",
        14,
        2,
        user,
        maximumPosition + 1,
        gasLimit
      );
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should not be able to create a new short order with over maximum position", async () => {
    try {
      await createShortOrder(
        instance,
        "ebin",
        14,
        2,
        user,
        maximumPosition + 1,
        gasLimit
      );
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should not be able to create duplicate orders", async () => {
    try {
      await createShortOrder(
        instance,
        "ebin",
        14,
        2,
        user,
        minimumPosition,
        gasLimit
      );
      await createShortOrder(
        instance,
        "ebin",
        14,
        2,
        user,
        minimumPosition,
        gasLimit
      );
      return true;
    } catch (e) {
      return false;
    }
  });
});
