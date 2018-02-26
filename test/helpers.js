// eslint-disable-next-line
const BigNumber = web3.BigNumber;
const should = require("chai")
  .use(require("chai-as-promised"))
  .use(require("chai-bignumber")(BigNumber))
  .should();
BigNumber.config({ DECIMAL_PLACES: 0 });
const EVMThrow = "invalid opcode";
module.exports = { should, EVMThrow, BigNumber };
