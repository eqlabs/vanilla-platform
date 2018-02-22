// eslint-disable-next-line
const LongShortController = artifacts.require(
  "../contracts/LongShortController.sol"
);
// eslint-disable-next-line
const Oracle = artifacts.require("../contracts/Oracle.sol");
// eslint-disable-next-line
const { should, BigNumber } = require("./helpers");

const matchedOrders = require("./orderExamples.json");

async function openLongShort(
  instance,
  sender,
  amount,
  parameterHash,
  duration,
  leverage,
  ownerSignatures,
  paymentAddresses,
  balances,
  positionTypes
) {
  return await instance.openLongShort(
    parameterHash,
    duration,
    leverage,
    ownerSignatures,
    paymentAddresses,
    balances,
    positionTypes,
    {
      from: sender,
      value: amount
    }
  );
}

// eslint-disable-next-line
contract("LongShortController", ([owner, user, feeWallet]) => {
  let instance, oracle;

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await LongShortController.new(owner);
      oracle = await Oracle.new(owner);
      await instance.linkOracle(oracle.address, {
        from: owner
      });
    }
  );

  it("Should set owner as owner", async () => {
    const contract_owner = await instance.owner.call();
    contract_owner.should.equal(owner);
  });

  it("Should be able to open a longshort with an equal amount of parameters", async () => {
    const numOrders = 12;
    const availableAddresses = [owner, user];

    const positionTypes = [];
    const ownerSignatures = [];
    const balances = [];
    const paymentAddresses = [];

    for (let i = 0; i < numOrders; i++) {
      const orderIndex = i % 2;
      positionTypes.push(matchedOrders[orderIndex].positionType);
      ownerSignatures.push(matchedOrders[orderIndex].ownerSignature);
      balances.push(matchedOrders[orderIndex].balance);
      paymentAddresses.push(availableAddresses[orderIndex]);
    }

    const totalBalance = balances.reduce((a, b) => a + b);

    await openLongShort(
      instance,
      owner,
      totalBalance,
      "hg79a8shgufdilhsagf89ds",
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      positionTypes
    );

    //eslint-disable-next-line
    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(totalBalance);
  });

  it("Should not be able to open a longshort with an inequal amount of parameters", async () => {
    const numOrders = 12;
    const availableAddresses = [owner, user];

    const positionTypes = [];
    const ownerSignatures = [];
    const balances = [];
    const paymentAddresses = [];

    for (let i = 0; i < numOrders; i++) {
      const orderIndex = i % 2;
      positionTypes.push(matchedOrders[orderIndex].positionType);
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
      "hg79a8shgufdilhsagf89ds",
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      positionTypes
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to open a longshort without a null-sum result", async () => {
    const numOrders = 12;
    const availableAddresses = [owner, user];

    const positionTypes = [];
    const ownerSignatures = [];
    const balances = [];
    const paymentAddresses = [];

    for (let i = 0; i < numOrders; i++) {
      const orderIndex = i % 2;
      positionTypes.push(matchedOrders[orderIndex].positionType);
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
      "hg79a8shgufdilhsagf89ds",
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      positionTypes
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should get active closing dates", async () => {
    const numOrders = 12;
    const availableAddresses = [owner, user];

    const positionTypes = [];
    const ownerSignatures = [];
    const balances = [];
    const paymentAddresses = [];

    for (let i = 0; i < numOrders; i++) {
      const orderIndex = i % 2;
      positionTypes.push(matchedOrders[orderIndex].positionType);
      ownerSignatures.push(matchedOrders[orderIndex].ownerSignature);
      balances.push(matchedOrders[orderIndex].balance);
      paymentAddresses.push(availableAddresses[orderIndex]);
    }

    const totalBalance = balances.reduce((a, b) => a + b);

    await openLongShort(
      instance,
      owner,
      totalBalance,
      "hg79a8shgufdilhsagf89ds",
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      positionTypes
    );

    //eslint-disable-next-line
    const closingDates = await instance.getActiveClosingDates({
      from: owner
    });

    closingDates.should.have.length.gt(0);
  });

  it("Should be able to exercise LongShorts on closing date", async () => {
    const numOrders = 12;
    const availableAddresses = [owner, user];

    const positionTypes = [];
    const ownerSignatures = [];
    const balances = [];
    const paymentAddresses = [];

    for (let i = 0; i < numOrders; i++) {
      const orderIndex = i % 2;
      positionTypes.push(matchedOrders[orderIndex].positionType);
      ownerSignatures.push(matchedOrders[orderIndex].ownerSignature);
      balances.push(matchedOrders[orderIndex].balance);
      paymentAddresses.push(availableAddresses[orderIndex]);
    }

    const totalBalance = balances.reduce((a, b) => a + b);

    await openLongShort(
      instance,
      owner,
      totalBalance,
      "hg79a8shgufdilhsagf89ds",
      0,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      positionTypes
    );

    await oracle.setLatestPrice(900 * 2, {
      from: owner
    });

    //eslint-disable-next-line
    const closingDates = await instance.getActiveClosingDates({
      from: owner
    });

    await instance.exercise(closingDates[0]);

    const paymentsLength = await instance.getPaymentsLength({
      from: owner
    });

    paymentsLength.c[0].should.equal(12);

    await instance.payRewards();
  });
});
