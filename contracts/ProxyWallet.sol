pragma solidity ^0.4.26;
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

  /**
  @dev Watchable events for the backend server to
  keep taps of things happening in the proxy wallets.
  */
  event PaymentReceived(uint updatedBalance);
  event UserRefunded(address userAddress);

  /**
  @dev Simple payment endpoint, that
  accumulates funds in the contract
  */
  function() public payable {
    emit PaymentReceived(msg.value);
  }

  /**
  @dev Refund the user
  @param paymentAddress the address to transfer the funds to
  */
  function refund(address paymentAddress) public onlyOwner {
    require(paymentAddress!=owner, "The owner can't refund itself");
    paymentAddress.transfer(address(this).balance);
    emit UserRefunded(paymentAddress);
  }

}
