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

ProxyWallet.PaymentReceived(updatedBalance) `1a07f76e`

Arguments

| | | |
|-|-|-|
| *uint256* | updatedBalance | not indexed |

## *event* UserRefunded

ProxyWallet.UserRefunded(userAddress) `64a19944`

Arguments

| | | |
|-|-|-|
| *address* | userAddress | not indexed |

## *event* OwnershipTransferred

ProxyWallet.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

Arguments

| | | |
|-|-|-|
| *address* | previousOwner | indexed |
| *address* | newOwner | indexed |


---