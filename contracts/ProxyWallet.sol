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
  // Balance of the contract in Wei
  uint256 private balance;

  /**
   * Watchable events for the backend server to
   * keep taps of things happening in the proxy wallets.
   */
  event PaymentReceived(address thisContract, uint updatedBalance);
  event UserRefunded(address thisContract, address userAddress);
  event ContractDestroyed(address thisContract);

  /**
   * Simple payment endpoint, that
   * accumulates funds in the contract.
   */
  function() public payable {
    balance += msg.value;
    PaymentReceived(this, balance);
  }

  /**
   * Getter for the balance of the proxy wallet
   * @returns uint balance – the total balance of the contract in Wei
   */
  function getBalance() public returns (uint) {
    return balance;
  }

  /**
   * Refund the user
   * @param address paymentAddress
   */
  function refund(address paymentAddress) public onlyOwner {
    paymentAddress.transfer(balance);
    UserRefunded(this, paymentAddress);
  }

  /**
   * Destroys the proxy wallet,
   * calling Solidity's selfdestruct()
   */
  function destroy() public onlyOwner {
    ContractDestroyed(this);
    selfdestruct();
  }
}
