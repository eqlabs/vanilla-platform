* [Ownable](#ownable)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [ProxyWallet](#proxywallet)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [refund](#function-refund)
  * [PaymentReceived](#event-paymentreceived)
  * [UserRefunded](#event-userrefunded)
  * [ContractDestroyed](#event-contractdestroyed)
  * [OwnershipTransferred](#event-ownershiptransferred)

# Ownable


## *function* owner

Ownable.owner() `view` `8da5cb5b`





## *function* transferOwnership

Ownable.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |


## *event* OwnershipTransferred

Ownable.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

Arguments

| | | |
|-|-|-|
| *address* | previousOwner | indexed |
| *address* | newOwner | indexed |


---
# ProxyWallet

Convoluted Labs

## *function* owner

ProxyWallet.owner() `view` `8da5cb5b`





## *function* transferOwnership

ProxyWallet.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |


## *function* refund

ProxyWallet.refund(paymentAddress) `nonpayable` `fa89401a`

> Refund the user

Inputs

| | | |
|-|-|-|
| *address* | paymentAddress | the address to transfer the funds to |


## *event* PaymentReceived

ProxyWallet.PaymentReceived(proxyWalletAddress, updatedBalance) `6ef95f06`

Arguments

| | | |
|-|-|-|
| *address* | proxyWalletAddress | not indexed |
| *uint256* | updatedBalance | not indexed |

## *event* UserRefunded

ProxyWallet.UserRefunded(proxyWalletAddress, userAddress) `0561c3fb`

Arguments

| | | |
|-|-|-|
| *address* | proxyWalletAddress | not indexed |
| *address* | userAddress | not indexed |

## *event* ContractDestroyed

ProxyWallet.ContractDestroyed(proxyWalletAddress) `3ab1d791`

Arguments

| | | |
|-|-|-|
| *address* | proxyWalletAddress | not indexed |

## *event* OwnershipTransferred

ProxyWallet.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

Arguments

| | | |
|-|-|-|
| *address* | previousOwner | indexed |
| *address* | newOwner | indexed |


---