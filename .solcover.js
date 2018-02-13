module.exports = {
  port: 8545, // Specify ganache-cli port
  copyNodeModules: true, // Tell solidity-coverage to copy npm packages
  norpc: true // Disable solidity-coverage from deploying its own test net
};
