pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * Proxy wallet, spawned and managed by our backend.
 * The order parameters are saved to our backend.
 * This only stores the balance for the user.
 *
 * When enough funds are transferred, the backend sends the funds
 * with the parameters to the OrdersManager.sol contract.
 *
 * @author Nordic Venture Family Code Distillery
 */
contract ProxyWallet is Ownable {

  // Balance of the contract
  uint256 private balance;

  // TODO: add events

  /**
   * Simple payment endpoint, that
   * accumulates funds in the contract.
   */
  function() public payable {
    balance += msg.value;
  }

  /**
   * Getter for the balance of the proxy wallet
   */
  function getBalance() public returns (uint) {
    return balance;
  }

  /**
   * Destroys the proxy wallet, transferring the remaining balance
   * to the user.
   */
  function destroyProxyWallet(address paymentAddress) public onlyOwner {
    paymentAddress.transfer(balance);
    selfdestruct();
  }
}
