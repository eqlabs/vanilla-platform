// eslint-disable-next-line
const OrdersManager = artifacts.require("../contracts/OrdersManager.sol");
// eslint-disable-next-line
const { should } = require("./helpers");

// eslint-disable-next-line
contract("OrdersManager", ([owner, user, feeWallet]) => {
  let instance;
  const transactionValue = 20000000;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await OrdersManager.new(owner);
    }
  );

  it("Should set owner as owner", async () => {
    const contract_owner = await instance.owner.call();
    contract_owner.should.equal(owner);
  });

  it("Should be able to set the fee wallet as the owner", async () => {
    try {
      await instance.setFeeWallet(feeWallet, { from: owner });
      return true;
    } catch (e) {
      return false;
    }
  });

  it("Should not be able to set the fee wallet by anyone but the owner", async () => {
    try {
      await instance.setFeeWallet(feeWallet, { from: owner });
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should be able to create a new short order", async () => {
    await instance.createOrder(
      Math.round(new Date().getTime() / 1000),
      2,
      false,
      user,
      {
        from: user,
        value: transactionValue
      }
    );
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(transactionValue);
  });

  it("Should be able to create a new long order", async () => {
    await instance.createOrder(
      Math.round(new Date().getTime() / 1000),
      2,
      true,
      user,
      {
        from: user,
        value: transactionValue
      }
    );
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(transactionValue);
  });

  it("Should refuse matching when there's no orders", async () => {
    try {
      await instance.matchMaker({
        from: owner
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
          value: transactionValue
        }
      );
      // Try to run matchmaker
      await instance.matchMaker({
        from: owner
      });
      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should be able to match orders and pay fees", async () => {
    // Set fee wallet address
    await instance.setFeeWallet(feeWallet, { from: owner });

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
        value: transactionValue
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
        value: transactionValue
      }
    );

    // Check balance
    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(transactionValue * 2);

    // Run matchmaker
    await instance.matchMaker({
      from: user
    });

    // Get fee balance
    //eslint-disable-next-line
    const feeBalance = await web3.eth.getBalance(feeWallet);
    feeBalance.should.be.bignumber.equal(
      initBalance + transactionValue * 2 * 0.3
    );
  });
});
