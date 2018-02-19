// eslint-disable-next-line
const LongShortController = artifacts.require(
  "../contracts/LongShortController.sol"
);
// eslint-disable-next-line
const { should, BigNumber } = require("./helpers");

const matchedOrders = require("./orderExamples.json");

async function openLongShort(
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
  return await instance.openLongShort(
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
  let instance;
  const gasLimit = 0xfffffffffff;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await LongShortController.new(owner);
    }
  );

  it("Should set owner as owner", async () => {
    const contract_owner = await instance.owner.call();
    contract_owner.should.equal(owner);
  });

  it("Should be able to open a longshort with an equal amount of parameters", async () => {
    const numOrders = 12;
    const availableAddresses = [owner, user];

    const isLongs = [];
    const ownerSignatures = [];
    const balances = [];
    const paymentAddresses = [];

    for (let i = 0; i < numOrders; i++) {
      const orderIndex = i % 2;
      isLongs.push(matchedOrders[orderIndex].isLong);
      ownerSignatures.push(matchedOrders[orderIndex].ownerSignature);
      balances.push(matchedOrders[orderIndex].balance);
      paymentAddresses.push(availableAddresses[orderIndex]);
    }

    const totalBalance = balances.reduce((a, b) => a + b);

    await openLongShort(
      instance,
      owner,
      totalBalance,
      gasLimit,
      "hg79a8shgufdilhsagf89ds",
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    );

    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(totalBalance);
  });

  it("Should not be able to open a longshort with an inequal amount of parameters", async () => {
    try {
      const numOrders = 12;
      const availableAddresses = [owner, user];

      const isLongs = [];
      const ownerSignatures = [];
      const balances = [];
      const paymentAddresses = [];

      for (let i = 0; i < numOrders; i++) {
        const orderIndex = i % 2;
        isLongs.push(matchedOrders[orderIndex].isLong);
        if (orderIndex === 0) {
          ownerSignatures.push(matchedOrders[orderIndex].ownerSignature);
        }
        balances.push(matchedOrders[orderIndex].balance);
        paymentAddresses.push(availableAddresses[orderIndex]);
      }

      const totalBalance = balances.reduce((a, b) => a + b);

      await openLongShort(
        instance,
        owner,
        totalBalance,
        gasLimit,
        "hg79a8shgufdilhsagf89ds",
        1209600,
        2,
        ownerSignatures,
        paymentAddresses,
        balances,
        isLongs
      );

      return false;
    } catch (e) {
      return true;
    }
  });

  it("Should not be able to open a longshort without a null-sum result", async () => {
    try {
      const numOrders = 12;
      const availableAddresses = [owner, user];

      const isLongs = [];
      const ownerSignatures = [];
      const balances = [];
      const paymentAddresses = [];

      for (let i = 0; i < numOrders; i++) {
        const orderIndex = i % 2;
        isLongs.push(matchedOrders[orderIndex].isLong);
        ownerSignatures.push(matchedOrders[orderIndex].ownerSignature);
        if (orderIndex === 0) {
          balances.push(matchedOrders[orderIndex].balance);
        } else {
          balances.push(matchedOrders[orderIndex].balance - 2);
        }
        paymentAddresses.push(availableAddresses[orderIndex]);
      }

      const totalBalance = balances.reduce((a, b) => a + b);

      await openLongShort(
        instance,
        owner,
        totalBalance,
        gasLimit,
        "hg79a8shgufdilhsagf89ds",
        1209600,
        2,
        ownerSignatures,
        paymentAddresses,
        balances,
        isLongs
      );

      return false;
    } catch (e) {
      return true;
    }
  });
});
