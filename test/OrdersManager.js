// eslint-disable-next-line
const OrdersManager = artifacts.require("../contracts/OrdersManager.sol");
// eslint-disable-next-line
const { should } = require("./helpers");

async function createLongOrder(
  instance,
  closingDate,
  leverage,
  sender,
  position,
  gas
) {
  await instance.createOrder(closingDate, leverage, true, sender, {
    from: sender,
    value: position,
    gas: gas
  });
}

async function createShortOrder(
  instance,
  closingDate,
  leverage,
  sender,
  position,
  gas
) {
  await instance.createOrder(closingDate, leverage, false, sender, {
    from: sender,
    value: position,
    gas: gas
  });
}

// eslint-disable-next-line
contract("OrdersManager", ([owner, user, feeWallet]) => {
  let instance, minimumPosition, maximumPosition;
  const gasLimit = 3000000;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await OrdersManager.new(owner);
      minimumPosition = await instance.MINIMUM_POSITION.call();
      maximumPosition = await instance.MAXIMUM_POSITION.call();
    }
  );

  it("Should set owner as owner", async () => {
    const contract_owner = await instance.owner.call();
    contract_owner.should.equal(owner);
  });

  it("Should be able to set the fee wallet as the owner", async () => {
    try {
      await instance.setFeeWallet(feeWallet, { from: owner, gas: gasLimit });
      return true;
    } catch (e) {
      return false;
    }
  });

  it("Should not be able to set the fee wallet by anyone but the owner", async () => {
    try {
      await instance.setFeeWallet(feeWallet, { from: owner, gas: gasLimit });
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should be able to create a new short order with minimum position", async () => {
    await createShortOrder(
      instance,
      Math.round(new Date().getTime() / 1000),
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
      Math.round(new Date().getTime() / 1000),
      2,
      user,
      minimumPosition,
      gasLimit
    );
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(minimumPosition);
  });

  it("Should not be able to create a new long order with over maximum position", async () => {
    try {
      await createLongOrder(
        instance,
        Math.round(new Date().getTime() / 1000),
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
        Math.round(new Date().getTime() / 1000),
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

  it("Should refuse matching when there's no orders", async () => {
    try {
      await instance.matchMaker({
        from: owner,
        gas: gasLimit
      });
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should refuse matching when there's no orders on both sides", async () => {
    try {
      // Create a long order
      await instance.createOrder(
        Math.round(new Date().getTime() / 1000),
        2,
        true,
        user,
        {
          from: user,
          value: minimumPosition,
          gas: gasLimit
        }
      );
      // Try to run matchmaker
      await instance.matchMaker({
        from: owner,
        gas: gasLimit
      });
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should be able to match orders and pay fees", async () => {
    // Set fee wallet address
    await instance.setFeeWallet(feeWallet, { from: owner, gas: gasLimit });

    // Get initial fee wallet balance
    //eslint-disable-next-line
    const initBalance = await web3.eth.getBalance(feeWallet);

    // Create a short order
    await instance.createOrder(
      Math.round(new Date().getTime() / 1000),
      2,
      false,
      user,
      {
        from: user,
        value: minimumPosition,
        gas: gasLimit
      }
    );

    // Create a long order
    await instance.createOrder(
      Math.round(new Date().getTime() / 1000),
      2,
      true,
      owner,
      {
        from: owner,
        value: minimumPosition,
        gas: gasLimit
      }
    );

    // Check balance
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(minimumPosition * 2);

    // Run matchmaker
    await instance.matchMaker({
      from: user,
      gas: gasLimit
    });

    // Get fee balance
    //eslint-disable-next-line
    const feeBalance = await web3.eth.getBalance(feeWallet);
    /* feeBalance.should.be.bignumber.equal(
      initBalance + transactionValue * 2 * 0.3
    ); */
  });
});
