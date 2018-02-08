// eslint-disable-next-line
const ProxyWallet = artifacts.require("../contracts/ProxyWallet.sol");
// eslint-disable-next-line
const { should } = require("./helpers");

// eslint-disable-next-line
contract("ProxyWallet", accounts => {
  let instance;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await ProxyWallet.new(accounts[0]);
    }
  );

  it("Should set owner as accounts[0]", async () => {
    const owner = await instance.owner.call();
    owner.should.equal(accounts[0]);
  });

  it("Should put 5 wei in the contract", async () => {
    await instance.sendTransaction({ value: 5, from: accounts[1] });
    const balance = await instance.balance.call();
    balance.should.be.bignumber.equal(5);
  });

  it("Should refund the user", async () => {
    await instance.sendTransaction({ value: 5, from: accounts[1] });
    const initialBalance = await instance.balance.call();
    initialBalance.should.be.bignumber.equal(5);
    await instance.refund(accounts[1], { from: accounts[0] });
    const updatedBalance = await instance.balance.call();
    updatedBalance.should.be.bignumber.equal(0);
  });

  it("Should refuse to destroy when balance is over 0", async () => {
    await instance.sendTransaction({ value: 5, from: accounts[1] });
    try {
      await instance.destroy({ from: accounts[0] });
    } catch (e) {
      return true;
    }
  });

  it("Should be able to destroy when balance is 0", async () => {
    try {
      await instance.destroy({ from: accounts[0] });
      return true;
    } catch (e) {
      return false;
    }
  });
});
