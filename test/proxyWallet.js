const ProxyWallet = artifacts.require("../contracts/ProxyWallet.sol");
const { should } = require("./helpers");

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
    const balance = await instance.getBalance.call();
    balance.should.be.bignumber.equal(5);
  });

  /* it("Should refund", async () => {
    await instance.sendTransaction({ value: 5, from: accounts[1] });
    await instance.refund.call(accounts[1]);
    const balance = await instance.getBalance.call();
    balance.should.be.bignumber.equal(0);
  }); */
});
