const ProxyWallet = artifacts.require("../contracts/ProxyWallet.sol");
const OrdersManager = artifacts.require("../contracts/OrdersManager.sol");
module.exports = function(deployer) {
  deployer.deploy(ProxyWallet);
  deployer.deploy(OrdersManager);
};
