const LongShortController = artifacts.require(
  "../contracts/LongShortController.sol"
);
const Oracle = artifacts.require("../contracts/Oracle.sol");
// eslint-disable-next-line
const { should, BigNumber } = require("./helpers");

const matchedOrders = require("./orderExamples.json");

async function openLongShort(
  instance,
  sender,
  amount,
  parameterHash,
  currencyPair,
  duration,
  leverage,
  ownerSignatures,
  paymentAddresses,
  balances,
  isLongs
) {
  return await instance.openLongShort(
    parameterHash,
    currencyPair,
    duration,
    leverage,
    ownerSignatures,
    paymentAddresses,
    balances,
    isLongs,
    {
      from: sender,
      value: amount
    }
  );
}

contract("LongShortController", ([owner, user]) => {
  let instance, oracle;
  const currencyPair = "ETH-USD";
  const initialPrice = new BigNumber("900");
  const decreasedPrice = initialPrice.sub("100");
  const increasedPrice = initialPrice.add("100");
  const highPrice = initialPrice.div("2").add(initialPrice);
  const lowPrice = initialPrice.sub(initialPrice.div("2"));

  beforeEach(
    "Start a new instance of the contract for each test",
    async function() {
      instance = await LongShortController.new(owner);
      await instance.toggleDebug({
        from: owner
      });
      oracle = await Oracle.new({ from: owner });
      await oracle.setLatestPrices([currencyPair], [initialPrice], {
        from: owner
      });
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    );

    const balance = await web3.eth.getBalance(instance.address);
    balance.should.be.bignumber.equal(totalBalance);
  });

  it("Should not be able to open a longshort with an inequal amount of parameters", async () => {
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should not be able to open a longshort without a null-sum result", async () => {
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    )
      .then(r => r.tx.should.not.exist)
      .catch(e => e.toString().should.include("revert"));
  });

  it("Should get active closing dates", async () => {
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      1209600,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    );

    const closingDates = await instance.getActiveClosingDates();

    closingDates.should.not.be.empty;
  });

  it("Should be able to exercise LongShorts on closing date", async () => {
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      0,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    );

    await oracle.setLatestPrices([currencyPair], [lowPrice], {
      from: owner
    });

    let closingDates = await instance.getActiveClosingDates();

    const longShortHashes = await instance.getLongShortHashes(closingDates[0], {
      from: owner
    });

    await instance.ping(longShortHashes[0]);

    let rewardableAddresses = await instance.getRewardableAddresses({
      from: owner
    });

    rewardableAddresses.length.should.equal(12);

    rewardableAddresses.map(
      async address => await instance.withdrawReward(address)
    );

    rewardableAddresses = await instance.getRewardableAddresses({
      from: owner
    });

    rewardableAddresses.length.should.equal(0);

    const controllerBalance = await web3.eth.getBalance(instance.address);

    controllerBalance.should.be.bignumber.equal(0);

    closingDates = await instance.getActiveClosingDates();
    closingDates.should.be.empty;
  });

  it("Price increase of 50% with a leverage of 2 should cause a margin call", async () => {
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      14,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    );

    await oracle.setLatestPrices([currencyPair], [highPrice], {
      from: owner
    });

    let closingDates = await instance.getActiveClosingDates();

    const longShortHashes = await instance.getLongShortHashes(closingDates[0], {
      from: owner
    });

    await instance.ping(longShortHashes[0]);

    let rewardableAddresses = await instance.getRewardableAddresses({
      from: owner
    });

    rewardableAddresses.length.should.equal(12);

    rewardableAddresses.map(
      async address => await instance.withdrawReward(address)
    );

    rewardableAddresses = await instance.getRewardableAddresses({
      from: owner
    });

    rewardableAddresses.length.should.equal(0);

    const controllerBalance = await web3.eth.getBalance(instance.address);

    controllerBalance.should.be.bignumber.equal(0);

    closingDates = await instance.getActiveClosingDates();
    closingDates.should.be.empty;
  });

  it("Price decrease of 50% with a leverage of 2 should cause a margin call", async () => {
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      14,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    );

    await oracle.setLatestPrices([currencyPair], [lowPrice], {
      from: owner
    });

    let closingDates = await instance.getActiveClosingDates();

    const longShortHashes = await instance.getLongShortHashes(closingDates[0], {
      from: owner
    });

    await instance.ping(longShortHashes[0]);

    let rewardableAddresses = await instance.getRewardableAddresses({
      from: owner
    });

    rewardableAddresses.length.should.equal(12);

    rewardableAddresses.map(
      async address => await instance.withdrawReward(address)
    );

    rewardableAddresses = await instance.getRewardableAddresses({
      from: owner
    });

    rewardableAddresses.length.should.equal(0);

    const controllerBalance = await web3.eth.getBalance(instance.address);

    controllerBalance.should.be.bignumber.equal(0);

    closingDates = await instance.getActiveClosingDates();
    closingDates.should.be.empty;
  });

  it("Should not close LongShorts when pinged", async () => {
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
      "hg79a8shgufdilhsagf89ds",
      currencyPair,
      14,
      2,
      ownerSignatures,
      paymentAddresses,
      balances,
      isLongs
    );

    await oracle.setLatestPrices([currencyPair], [increasedPrice], {
      from: owner
    });

    let closingDates = await instance.getActiveClosingDates();

    const longShortHashes = await instance.getLongShortHashes(closingDates[0], {
      from: owner
    });

    await instance.ping(longShortHashes[0]);

    const rewardableAddresses = await instance.getRewardableAddresses({
      from: owner
    });

    rewardableAddresses.length.should.equal(0);
  });

  it("Should calculate rewards correctly for long positions on maximum price decrease", async () => {
    const balance = 8000;
    const reward = await instance.calculateReward(
      true,
      balance,
      2,
      initialPrice,
      lowPrice,
      { from: user }
    );
    reward.should.be.bignumber.equal(0);
  });

  it("Should calculate rewards correctly for long positions on maximum price increase", async () => {
    const balance = 8000;
    const reward = await instance.calculateReward(
      true,
      balance,
      2,
      initialPrice,
      highPrice,
      { from: user }
    );
    reward.should.be.bignumber.equal(balance * 2);
  });

  it("Should calculate rewards correctly for short positions on a little price decrease", async () => {
    const balance = new BigNumber("8000");
    const reward = await instance.calculateReward(
      false,
      balance,
      2,
      initialPrice,
      decreasedPrice,
      { from: user }
    );
    const priceDiff = initialPrice.sub(decreasedPrice);
    const diffPercentage = priceDiff
      .mul("10000")
      .mul("2")
      .div(initialPrice);
    const balanceDiff = balance.mul(diffPercentage).div("10000");
    const expectedReward = balance.add(balanceDiff);
    reward.should.be.bignumber.equal(expectedReward);
  });

  it("Should calculate rewards correctly for short positions on a little price increase", async () => {
    const balance = new BigNumber("8000");
    const reward = await instance.calculateReward(
      false,
      balance,
      2,
      initialPrice,
      increasedPrice,
      { from: user }
    );
    const priceDiff = increasedPrice.sub(initialPrice);
    const diffPercentage = priceDiff
      .mul("10000")
      .mul("2")
      .div(initialPrice);
    const balanceDiff = balance.mul(diffPercentage).div("10000");
    const expectedReward = balance.sub(balanceDiff);
    reward.should.be.bignumber.equal(expectedReward);
  });
});
