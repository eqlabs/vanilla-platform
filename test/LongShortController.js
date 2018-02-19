// eslint-disable-next-line
const LongShortController = artifacts.require(
  "../contracts/LongShortController.sol"
);
// eslint-disable-next-line
const { should, BigNumber } = require("./helpers");

async function createLongShort(
  instance,
  sender,
  amount,
  gasLimit,
  parameterHash,
  duration,
  leverage,
  ownerSignatures,
  paymentAddresses,
  balances,
  isLongs
) {
  return await instance.createOrder(
    parameterHash,
    duration,
    leverage,
    ownerSignatures,
    paymentAddresses,
    balances,
    isLongs,
    {
      from: sender,
      value: amount,
      gasLimit: gasLimit
    }
  );
}

// eslint-disable-next-line
contract("LongShortController", ([owner, user, feeWallet]) => {
  let instance, minimumPosition, maximumPosition;
  let gasLimit = 0xfffffffffff;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await LongShortController.new(owner);
      minimumPosition = await instance.MINIMUM_POSITION.call();
      minimumPosition = new BigNumber(minimumPosition);
      maximumPosition = await instance.MAXIMUM_POSITION.call();
      maximumPosition = new BigNumber(maximumPosition);
    }
  );

  it("Should set owner as owner", async () => {
    const contract_owner = await instance.owner;
    contract_owner.should.equal(owner);
  });
});
