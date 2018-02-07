const ProxyWallet = artifacts.require("../contracts/ProxyWallet.sol");
module.exports = function(deployer) {
  deployer.deploy(ProxyWallet);
};
