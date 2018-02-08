// eslint-disable-next-line
const OrdersManager = artifacts.require("../contracts/OrdersManager.sol");
// eslint-disable-next-line
const { should } = require("./helpers");

// eslint-disable-next-line
contract("OrdersManager", accounts => {
  let instance;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await OrdersManager.new(accounts[0]);
    }
  );

  it("Should set owner as accounts[0]", async () => {
    const owner = await instance.owner.call();
    owner.should.equal(accounts[0]);
  });
});
