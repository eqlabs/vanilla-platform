//eslint-disable-next-line
const ProxyWallet = artifacts.require("../contracts/ProxyWallet.sol");
//eslint-disable-next-line
const OrdersManager = artifacts.require("../contracts/OrdersManager.sol");
//eslint-disable-next-line
const LongShortController = artifacts.require(
  "../contracts/LongShortController.sol"
);

module.exports = function(deployer) {
  deployer.deploy(ProxyWallet);
  deployer.deploy(OrdersManager);
  deployer.deploy(LongShortController);
};
