module.exports = {
  port: 8545, // Specify ganache-cli port
  copyPackages: ["zeppelin-solidity"], // Tell solidity-coverage to copy these npm packages
  norpc: true // Disable solidity-coverage from deploying its own test net
};
