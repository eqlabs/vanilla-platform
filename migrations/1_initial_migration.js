//eslint-disable-next-line
const ProxyWallet = artifacts.require("../contracts/ProxyWallet.sol");
//eslint-disable-next-line
const OrdersManager = artifacts.require("../contracts/OrdersManager.sol");
module.exports = function(deployer) {
  deployer.deploy(ProxyWallet);
  deployer.deploy(OrdersManager);
};
