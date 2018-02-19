* [Debuggable](#debuggable)
  * [debug](#function-debug)
  * [DebugEvent](#event-debugevent)
* [LongShortController](#longshortcontroller)
  * [getActiveClosingDates](#function-getactiveclosingdates)
  * [debug](#function-debug)
  * [owner](#function-owner)
  * [openLongShort](#function-openlongshort)
  * [transferOwnership](#function-transferownership)
  * [DebugEvent](#event-debugevent)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Migrations](#migrations)
  * [upgrade](#function-upgrade)
  * [last_completed_migration](#function-last_completed_migration)
  * [owner](#function-owner)
  * [setCompleted](#function-setcompleted)
* [OrdersManager](#ordersmanager)
  * [getOpenParameterHashes](#function-getopenparameterhashes)
  * [setSignature](#function-setsignature)
  * [debug](#function-debug)
  * [getOpenOrderIDs](#function-getopenorderids)
  * [getOrder](#function-getorder)
  * [createOrder](#function-createorder)
  * [MINIMUM_POSITION](#function-minimum_position)
  * [deleteOrder](#function-deleteorder)
  * [owner](#function-owner)
  * [updateOrderBalance](#function-updateorderbalance)
  * [setFeeWallet](#function-setfeewallet)
  * [withdrawFee](#function-withdrawfee)
  * [MAXIMUM_POSITION](#function-maximum_position)
  * [transferOwnership](#function-transferownership)
  * [DebugEvent](#event-debugevent)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Ownable](#ownable)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [ProxyWallet](#proxywallet)
  * [destroy](#function-destroy)
  * [owner](#function-owner)
  * [balance](#function-balance)
  * [transferOwnership](#function-transferownership)
  * [refund](#function-refund)
  * [PaymentReceived](#event-paymentreceived)
  * [UserRefunded](#event-userrefunded)
  * [ContractDestroyed](#event-contractdestroyed)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [SafeMath](#safemath)
* [Verify](#verify)
  * [isSigned](#function-issigned)
  * [recoverAddr](#function-recoveraddr)

# Debuggable


## *function* debug

Debuggable.debug(message) `nonpayable` `2f50fbfa`


Inputs

| | | |
|-|-|-|
| *string* | message | undefined |

## *event* DebugEvent

Debuggable.DebugEvent(message) `56f074d2`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |


---
# LongShortController

Convoluted Labs

## *function* getActiveClosingDates

LongShortController.getActiveClosingDates() `view` `1c6d1138`





## *function* debug

LongShortController.debug(message) `nonpayable` `2f50fbfa`


Inputs

| | | |
|-|-|-|
| *string* | message | undefined |


## *function* owner

LongShortController.owner() `view` `8da5cb5b`





## *function* openLongShort

LongShortController.openLongShort(parameterHash, duration, leverage, ownerSignatures, paymentAddresses, balances, isLongs) `payable` `dc7a1108`

> LongShort activator function. Called by OrdersManager.

Inputs

| | | |
|-|-|-|
| *bytes32* | parameterHash | undefined |
| *uint256* | duration | undefined |
| *uint256* | leverage | undefined |
| *bytes32[]* | ownerSignatures | undefined |
| *address[]* | paymentAddresses | undefined |
| *uint256[]* | balances | undefined |
| *bool[]* | isLongs | undefined |


## *function* transferOwnership

LongShortController.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |

## *event* DebugEvent

LongShortController.DebugEvent(message) `56f074d2`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |

## *event* OwnershipTransferred

LongShortController.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

Arguments

| | | |
|-|-|-|
| *address* | previousOwner | indexed |
| *address* | newOwner | indexed |


---
# Migrations


## *function* upgrade

Migrations.upgrade(new_address) `nonpayable` `0900f010`


Inputs

| | | |
|-|-|-|
| *address* | new_address | undefined |


## *function* last_completed_migration

Migrations.last_completed_migration() `view` `445df0ac`





## *function* owner

Migrations.owner() `view` `8da5cb5b`





## *function* setCompleted

Migrations.setCompleted(completed) `nonpayable` `fdacd576`


Inputs

| | | |
|-|-|-|
| *uint256* | completed | undefined |



---
# OrdersManager

Convoluted Labs

## *function* getOpenParameterHashes

OrdersManager.getOpenParameterHashes() `view` `0894da91`

> Returns open parameter hashes. Only callable by the owner.



Outputs

| | | |
|-|-|-|
| *bytes32[]* |  | undefined |

## *function* setSignature

OrdersManager.setSignature(signingSecret) `nonpayable` `2782fb22`

> Setter for the contract signature Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *string* | signingSecret | a salt used in parameter and order hashing |


## *function* debug

OrdersManager.debug(message) `nonpayable` `2f50fbfa`


Inputs

| | | |
|-|-|-|
| *string* | message | undefined |


## *function* getOpenOrderIDs

OrdersManager.getOpenOrderIDs(paramHash) `view` `538539c2`

> Returns open orders by hash Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | paramHash | Hash of duration, leverage and signature. |

Outputs

| | | |
|-|-|-|
| *bytes32[]* |  | undefined |

## *function* getOrder

OrdersManager.getOrder(orderHash) `view` `5778472a`

> Returns order by orderID. Deconstructs the Order struct for returning. Leaves out the ownerSignature.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderHash | An unique hash that maps to an order |

Outputs

| | | |
|-|-|-|
| *bool* |  | undefined |
| *uint256* |  | undefined |
| *uint256* |  | undefined |
| *address* |  | undefined |
| *uint256* |  | undefined |

## *function* createOrder

OrdersManager.createOrder(orderID, isLong, duration, leverage, paymentAddress) `payable` `6eb2760c`

> Open order creation, the main endpoint for Vanilla platform. Mainly called by Vanilla's own backend, but open for everyone who knows how to use the smart contract on its own. Receives a singular payment with parameters to open an order with.

Inputs

| | | |
|-|-|-|
| *string* | orderID | A unique ID to create the order with. Will be hashed. |
| *bool* | isLong | {long: true, short: false} |
| *uint256* | duration | Duration of the LongShort in seconds. For example, 14 days = 1209600 |
| *uint256* | leverage | uint of the wanted leverage |
| *address* | paymentAddress | address, to which the user wants the funds back whether he/she won or not |

Outputs

| | | |
|-|-|-|
| *bytes32* |  | undefined |

## *function* MINIMUM_POSITION

OrdersManager.MINIMUM_POSITION() `view` `7a0b89d3`





## *function* deleteOrder

OrdersManager.deleteOrder(orderHash) `nonpayable` `87a61cbd`

> Deletes an order by hash, effectively turning all its parameters to 0. Used by the backend after an order has been fully matched. Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderHash | The unique hash of the deletable order. |


## *function* owner

OrdersManager.owner() `view` `8da5cb5b`





## *function* updateOrderBalance

OrdersManager.updateOrderBalance(orderHash, newBalance) `nonpayable` `8fb08201`

> Updates an order's balance. Used by the backend when an order was partially matched. Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderHash | The unique hash of the deletable order. |
| *uint256* | newBalance | The new balance of an order. |


## *function* setFeeWallet

OrdersManager.setFeeWallet(feeWalletAddress) `nonpayable` `90d49b9d`

> Setter for Vanilla's fee wallet address Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *address* | feeWalletAddress | upcoming address that receives the fees |


## *function* withdrawFee

OrdersManager.withdrawFee() `nonpayable` `e941fa78`

> Pull payment function for sending the accumulated fees to Vanilla's fee wallet. Only callable by the owner.




## *function* MAXIMUM_POSITION

OrdersManager.MAXIMUM_POSITION() `view` `e9593ef4`





## *function* transferOwnership

OrdersManager.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |

## *event* DebugEvent

OrdersManager.DebugEvent(message) `56f074d2`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |

## *event* OwnershipTransferred

OrdersManager.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

Arguments

| | | |
|-|-|-|
| *address* | previousOwner | indexed |
| *address* | newOwner | indexed |


---
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

## *function* destroy

ProxyWallet.destroy() `nonpayable` `83197ef0`

> Destroys the proxy wallet, calling Solidity's selfdestruct(). Requires the contract balance to be 0 before destruction, so no user funds are transfered to us.




## *function* owner

ProxyWallet.owner() `view` `8da5cb5b`





## *function* balance

ProxyWallet.balance() `view` `b69ef8a8`





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
# SafeMath


---
# Verify


## *function* isSigned

Verify.isSigned(_addr, msgHash, v, r, s) `pure` `8677ebe8`


Inputs

| | | |
|-|-|-|
| *address* | _addr | undefined |
| *bytes32* | msgHash | undefined |
| *uint8* | v | undefined |
| *bytes32* | r | undefined |
| *bytes32* | s | undefined |


## *function* recoverAddr

Verify.recoverAddr(msgHash, v, r, s) `pure` `e5df669f`


Inputs

| | | |
|-|-|-|
| *bytes32* | msgHash | undefined |
| *uint8* | v | undefined |
| *bytes32* | r | undefined |
| *bytes32* | s | undefined |


---