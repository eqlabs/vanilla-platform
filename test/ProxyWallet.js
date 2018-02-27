const ProxyWallet = artifacts.require("../contracts/ProxyWallet.sol");
// eslint-disable-next-line
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
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(5);
  });

  it("Should refund the user", async () => {
    await instance.sendTransaction({ value: 5, from: accounts[1] });
    const initialBalance = await web3.eth.getBalance(instance.address);
    initialBalance.should.be.bignumber.equal(5);
    await instance.refund(accounts[1], { from: accounts[0] });
    const updatedBalance = await web3.eth.getBalance(instance.address);
    updatedBalance.should.be.bignumber.equal(0);
  });

  it("Should refuse to refund the owner", async () => {
    await instance.sendTransaction({ value: 5, from: accounts[1] });
    const initialBalance = await web3.eth.getBalance(instance.address);
    initialBalance.should.be.bignumber.equal(5);
    await instance
      .refund(accounts[0], { from: accounts[0] })
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should refuse to refund when called by anyone else but the owner", async () => {
    await instance.sendTransaction({ value: 5, from: accounts[1] });
    const initialBalance = await web3.eth.getBalance(instance.address);
    initialBalance.should.be.bignumber.equal(5);
    await instance
      .refund(accounts[1], { from: accounts[1] })
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });
});
