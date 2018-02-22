* [Debuggable](#debuggable)
  * [debug](#function-debug)
  * [DebugEvent](#event-debugevent)
* [OrdersManager](#ordersmanager)
  * [getOpenParameterHashes](#function-getopenparameterhashes)
  * [requireZeroSum](#function-requirezerosum)
  * [setSignature](#function-setsignature)
  * [debug](#function-debug)
  * [getOpenOrderIDs](#function-getopenorderids)
  * [getOrder](#function-getorder)
  * [CURRENCY_PAIRS](#function-currency_pairs)
  * [MINIMUM_POSITION](#function-minimum_position)
  * [deleteOrder](#function-deleteorder)
  * [owner](#function-owner)
  * [createOrder](#function-createorder)
  * [updateOrderBalance](#function-updateorderbalance)
  * [setFeeWallet](#function-setfeewallet)
  * [validateAllParameters](#function-validateallparameters)
  * [POSITION_TYPES](#function-position_types)
  * [LEVERAGES](#function-leverages)
  * [validateLeverage](#function-validateleverage)
  * [validatePositionType](#function-validatepositiontype)
  * [withdrawFee](#function-withdrawfee)
  * [MAXIMUM_POSITION](#function-maximum_position)
  * [transferOwnership](#function-transferownership)
  * [validateCurrencyPair](#function-validatecurrencypair)
  * [DebugEvent](#event-debugevent)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Ownable](#ownable)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [SafeMath](#safemath)
* [Validatable](#validatable)
  * [requireZeroSum](#function-requirezerosum)
  * [CURRENCY_PAIRS](#function-currency_pairs)
  * [validateAllParameters](#function-validateallparameters)
  * [POSITION_TYPES](#function-position_types)
  * [LEVERAGES](#function-leverages)
  * [validateLeverage](#function-validateleverage)
  * [validatePositionType](#function-validatepositiontype)
  * [validateCurrencyPair](#function-validatecurrencypair)

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


## *function* setSignature

OrdersManager.setSignature(signingSecret) `nonpayable` `2782fb22`

> Setter for the contract signature Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *string* | signingSecret | a salt used in parameter and order hashing |


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

OrdersManager.getOrder(orderHash) `view` `5778472a`

> Returns order by orderID. Deconstructs the Order struct for returning. Leaves out the ownerSignature.

Inputs

| | | |
|-|-|-|
| *bytes32* | orderHash | An unique hash that maps to an order |

Outputs

| | | |
|-|-|-|
| *string* |  | undefined |
| *string* |  | undefined |
| *uint256* |  | undefined |
| *uint256* |  | undefined |
| *address* |  | undefined |
| *uint256* |  | undefined |

## *function* CURRENCY_PAIRS

OrdersManager.CURRENCY_PAIRS() `view` `7a03aa3f`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


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





## *function* createOrder

OrdersManager.createOrder(orderID, currencyPair, positionType, duration, leverage, paymentAddress) `payable` `8da6c9e2`

> Open order creation, the main endpoint for Vanilla platform. Mainly called by Vanilla's own backend, but open for everyone who knows how to use the smart contract on its own. Receives a singular payment with parameters to open an order with.

Inputs

| | | |
|-|-|-|
| *string* | orderID | A unique ID to create the order with. Will be hashed. |
| *string* | currencyPair | "ETH-USD" || "BTC-USD" |
| *string* | positionType | "LONG" || "SHORT" |
| *uint256* | duration | Duration of the LongShort in seconds. For example, 14 days = 1209600 |
| *uint8* | leverage | uint of the wanted leverage |
| *address* | paymentAddress | address, to which the user wants the funds back whether he/she won or not |

Outputs

| | | |
|-|-|-|
| *bytes32* |  | undefined |

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


## *function* validateAllParameters

OrdersManager.validateAllParameters(currencyPair, positionType, leverage) `view` `a22d3dd2`


Inputs

| | | |
|-|-|-|
| *string* | currencyPair | undefined |
| *string* | positionType | undefined |
| *uint8* | leverage | undefined |


## *function* POSITION_TYPES

OrdersManager.POSITION_TYPES() `view` `ae2ed20f`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


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


## *function* validatePositionType

OrdersManager.validatePositionType(positionType) `view` `e7a026f1`


Inputs

| | | |
|-|-|-|
| *string* | positionType | undefined |


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


## *function* validateCurrencyPair

OrdersManager.validateCurrencyPair(currencyPair) `view` `fa748eac`


Inputs

| | | |
|-|-|-|
| *string* | currencyPair | undefined |

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


## *function* CURRENCY_PAIRS

Validatable.CURRENCY_PAIRS() `view` `7a03aa3f`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* validateAllParameters

Validatable.validateAllParameters(currencyPair, positionType, leverage) `view` `a22d3dd2`


Inputs

| | | |
|-|-|-|
| *string* | currencyPair | undefined |
| *string* | positionType | undefined |
| *uint8* | leverage | undefined |


## *function* POSITION_TYPES

Validatable.POSITION_TYPES() `view` `ae2ed20f`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


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


## *function* validatePositionType

Validatable.validatePositionType(positionType) `view` `e7a026f1`


Inputs

| | | |
|-|-|-|
| *string* | positionType | undefined |


## *function* validateCurrencyPair

Validatable.validateCurrencyPair(currencyPair) `view` `fa748eac`


Inputs

| | | |
|-|-|-|
| *string* | currencyPair | undefined |


---