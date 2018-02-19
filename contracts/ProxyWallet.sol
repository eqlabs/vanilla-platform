pragma solidity ^0.4.18;
import "./Ownable.sol";

/**
@dev Proxy wallet, spawned and managed by our backend.
The order parameters are saved to our backend.
This only stores the balance for the user.

When enough funds are transferred, the backend sends the funds
with the parameters to the OrdersManager.sol contract.

@author Convoluted Labs
*/
contract ProxyWallet is Ownable {
  // Balance of the contract in Wei
  uint256 public balance;

  /**
  @dev Watchable events for the backend server to
  keep taps of things happening in the proxy wallets.
  */
  event PaymentReceived(address proxyWalletAddress, uint updatedBalance);
  event UserRefunded(address proxyWalletAddress, address userAddress);
  event ContractDestroyed(address proxyWalletAddress);

  /**
  @dev Simple payment endpoint, that
  accumulates funds in the contract
  */
  function() public payable {
    balance += msg.value;
    PaymentReceived(this, balance);
  }

  /**
  @dev Refund the user
  @param paymentAddress - the address to transfer the funds to
  */
  function refund(address paymentAddress) public onlyOwner {
    require(paymentAddress!=owner);
    paymentAddress.transfer(balance);
    balance = 0;
    UserRefunded(this, paymentAddress);
  }

  /**
  @dev Destroys the proxy wallet,
  calling Solidity's selfdestruct().

  Requires the contract balance to be 0
  before destruction, so no user funds are
  transfered to us.
  */
  function destroy() public onlyOwner {

    // Require that the contract has been refunded before destroying it
    require(balance == 0);

    // Send the event of the destruction before it actually happening, because things
    ContractDestroyed(this);

    // Destroy the contract.
    selfdestruct(owner);

  }
}
