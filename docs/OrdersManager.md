* [Debuggable](#debuggable)
  * [debug](#function-debug)
  * [DebugEvent](#event-debugevent)
* [OrdersManager](#ordersmanager)
  * [getOpenParameterHashes](#function-getopenparameterhashes)
  * [requireZeroSum](#function-requirezerosum)
  * [debug](#function-debug)
  * [getOpenOrderIDs](#function-getopenorderids)
  * [getOrder](#function-getorder)
  * [MINIMUM_POSITION](#function-minimum_position)
  * [setSignature](#function-setsignature)
  * [deleteOrder](#function-deleteorder)
  * [owner](#function-owner)
  * [updateOrderBalance](#function-updateorderbalance)
  * [setFeeWallet](#function-setfeewallet)
  * [createOrder](#function-createorder)
  * [LEVERAGES](#function-leverages)
  * [validateLeverage](#function-validateleverage)
  * [withdrawFee](#function-withdrawfee)
  * [MAXIMUM_POSITION](#function-maximum_position)
  * [transferOwnership](#function-transferownership)
  * [DebugEvent](#event-debugevent)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Ownable](#ownable)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [SafeMath](#safemath)
* [Validatable](#validatable)
  * [requireZeroSum](#function-requirezerosum)
  * [LEVERAGES](#function-leverages)
  * [validateLeverage](#function-validateleverage)

# Debuggable

Convoluted Labs

## *function* debug

Debuggable.debug(message) `nonpayable` `2f50fbfa`

> Debug function that gets injected to extending contracts

Inputs

| | | |
|-|-|-|
| *string* | message | the message that we want to log/debug |

## *event* DebugEvent

Debuggable.DebugEvent(message) `56f074d2`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |


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

## *function* requireZeroSum

OrdersManager.requireZeroSum(isLongs, balances) `pure` `09d2ee7b`

> Helper function to check if both sides of the bet have same balance

Inputs

| | | |
|-|-|-|
| *bool[]* | isLongs | list of position types in boolean [true, false] |
| *uint256[]* | balances | list of position amounts in wei |


## *function* debug

OrdersManager.debug(message) `nonpayable` `2f50fbfa`

> Debug function that gets injected to extending contracts

Inputs

| | | |
|-|-|-|
| *string* | message | the message that we want to log/debug |


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

OrdersManager.getOrder(orderID) `view` `5778472a`

> Returns order by orderID. Deconstructs the Order struct for returning. Leaves out the ownerSignature.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderID | An unique hash that maps to an order |

Outputs

| | | |
|-|-|-|
| *bytes7* |  | undefined |
| *bytes5* |  | undefined |
| *uint256* |  | undefined |
| *uint256* |  | undefined |
| *address* |  | undefined |
| *uint256* |  | undefined |

## *function* MINIMUM_POSITION

OrdersManager.MINIMUM_POSITION() `view` `7a0b89d3`





## *function* setSignature

OrdersManager.setSignature(signingSecret) `nonpayable` `7f591fe2`

> Setter for the contract signature Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | signingSecret | a salt used in parameter and order hashing |


## *function* deleteOrder

OrdersManager.deleteOrder(orderID) `nonpayable` `87a61cbd`

> Deletes an order by hash, effectively turning all its parameters to 0. Used by the backend after an order has been fully matched. Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderID | The unique hash of the deletable order. |


## *function* owner

OrdersManager.owner() `view` `8da5cb5b`





## *function* updateOrderBalance

OrdersManager.updateOrderBalance(orderID, newBalance) `nonpayable` `8fb08201`

> Updates an order's balance. Used by the backend when an order was partially matched. Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderID | The unique hash of the deletable order. |
| *uint256* | newBalance | The new balance of an order. |


## *function* setFeeWallet

OrdersManager.setFeeWallet(feeWalletAddress) `nonpayable` `90d49b9d`

> Setter for Vanilla's fee wallet address Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *address* | feeWalletAddress | upcoming address that receives the fees |


## *function* createOrder

OrdersManager.createOrder(orderID, currencyPair, positionType, duration, leverage, paymentAddress) `payable` `b0387e34`

> Open order creation, the main endpoint for Vanilla platform. Mainly called by Vanilla's own backend, but open for everyone who knows how to use the smart contract on its own. Receives a singular payment with parameters to open an order with.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderID | A unique bytes32 ID to create the order with. |
| *bytes7* | currencyPair | "ETH-USD" || "BTC-USD" |
| *bytes5* | positionType | "LONG" || "SHORT" |
| *uint256* | duration | Duration of the LongShort in seconds. For example, 14 days = 1209600 |
| *uint8* | leverage | uint of the wanted leverage |
| *address* | paymentAddress | address, to which the user wants the funds back whether he/she won or not |


## *function* LEVERAGES

OrdersManager.LEVERAGES() `view` `cf90f950`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* validateLeverage

OrdersManager.validateLeverage(leverage) `view` `d806476d`


Inputs

| | | |
|-|-|-|
| *uint8* | leverage | undefined |


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
# SafeMath


---
# Validatable


## *function* requireZeroSum

Validatable.requireZeroSum(isLongs, balances) `pure` `09d2ee7b`

> Helper function to check if both sides of the bet have same balance

Inputs

| | | |
|-|-|-|
| *bool[]* | isLongs | list of position types in boolean [true, false] |
| *uint256[]* | balances | list of position amounts in wei |


## *function* LEVERAGES

Validatable.LEVERAGES() `view` `cf90f950`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* validateLeverage

Validatable.validateLeverage(leverage) `view` `d806476d`


Inputs

| | | |
|-|-|-|
| *uint8* | leverage | undefined |


---