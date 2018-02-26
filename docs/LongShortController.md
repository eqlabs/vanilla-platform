* [Debuggable](#debuggable)
  * [debugWithValue](#function-debugwithvalue)
  * [owner](#function-owner)
  * [debugString](#function-debugstring)
  * [toggleDebug](#function-toggledebug)
  * [transferOwnership](#function-transferownership)
  * [DebugString](#event-debugstring)
  * [DebugWithValue](#event-debugwithvalue)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [LongShortController](#longshortcontroller)
  * [requireZeroSum](#function-requirezerosum)
  * [activeClosingDates](#function-activeclosingdates)
  * [getActiveClosingDates](#function-getactiveclosingdates)
  * [ping](#function-ping)
  * [debugWithValue](#function-debugwithvalue)
  * [linkOracle](#function-linkoracle)
  * [payRewards](#function-payrewards)
  * [oracle](#function-oracle)
  * [owner](#function-owner)
  * [openLongShort](#function-openlongshort)
  * [calculateReward](#function-calculatereward)
  * [oracleAddress](#function-oracleaddress)
  * [debugString](#function-debugstring)
  * [getLongShortHashes](#function-getlongshorthashes)
  * [getLongShort](#function-getlongshort)
  * [LEVERAGES](#function-leverages)
  * [getRewardsLength](#function-getrewardslength)
  * [validateLeverage](#function-validateleverage)
  * [toggleDebug](#function-toggledebug)
  * [transferOwnership](#function-transferownership)
  * [DebugString](#event-debugstring)
  * [DebugWithValue](#event-debugwithvalue)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Oracle](#oracle)
  * [price](#function-price)
  * [setLatestPrices](#function-setlatestprices)
  * [debugWithValue](#function-debugwithvalue)
  * [owner](#function-owner)
  * [debugString](#function-debugstring)
  * [timesUpdated](#function-timesupdated)
  * [pricesByTime](#function-pricesbytime)
  * [toggleDebug](#function-toggledebug)
  * [transferOwnership](#function-transferownership)
  * [DebugString](#event-debugstring)
  * [DebugWithValue](#event-debugwithvalue)
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

## *function* debugWithValue

Debuggable.debugWithValue(message, value) `nonpayable` `5a47e57c`

> Debug a string with a value

Inputs

| | | |
|-|-|-|
| *string* | message | undefined |
| *uint256* | value | undefined |


## *function* owner

Debuggable.owner() `view` `8da5cb5b`





## *function* debugString

Debuggable.debugString(message) `nonpayable` `b6d929cf`

> Debug a string

Inputs

| | | |
|-|-|-|
| *string* | message | undefined |


## *function* toggleDebug

Debuggable.toggleDebug() `nonpayable` `ed998065`

> activates or deactivates the debug functionality.




## *function* transferOwnership

Debuggable.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |

## *event* DebugString

Debuggable.DebugString(message) `20670ef4`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |

## *event* DebugWithValue

Debuggable.DebugWithValue(message, value) `6e90aba1`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |
| *uint256* | value | not indexed |

## *event* OwnershipTransferred

Debuggable.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

Arguments

| | | |
|-|-|-|
| *address* | previousOwner | indexed |
| *address* | newOwner | indexed |


---
# LongShortController

Convoluted Labs

## *function* requireZeroSum

LongShortController.requireZeroSum(isLongs, balances) `pure` `09d2ee7b`

> Helper function to check if both sides of the bet have same balance

Inputs

| | | |
|-|-|-|
| *bool[]* | isLongs | list of position types in boolean [true, false] |
| *uint256[]* | balances | list of position amounts in wei |


## *function* activeClosingDates

LongShortController.activeClosingDates() `view` `18ee0aa3`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* getActiveClosingDates

LongShortController.getActiveClosingDates() `view` `1c6d1138`

> Gets all active closing dates from the contract



Outputs

| | | |
|-|-|-|
| *uint256[]* | closingDates | List of seconds from 1970. |

## *function* ping

LongShortController.ping(longShortHash) `nonpayable` `33d425c4`

> Function to ping a single LongShort with Checks if the price has increased or decreased enough for a margin call. Exercises the option when it's closing date is over expiry.

Inputs

| | | |
|-|-|-|
| *bytes32* | longShortHash | the unique identifier of a LongShort |


## *function* debugWithValue

LongShortController.debugWithValue(message, value) `nonpayable` `5a47e57c`

> Debug a string with a value

Inputs

| | | |
|-|-|-|
| *string* | message | undefined |
| *uint256* | value | undefined |


## *function* linkOracle

LongShortController.linkOracle(_oracleAddress) `nonpayable` `6b7ef2ee`

> Links Vanilla's oracle to the contract

Inputs

| | | |
|-|-|-|
| *address* | _oracleAddress | The address of the deployed oracle contract |


## *function* payRewards

LongShortController.payRewards() `nonpayable` `7288e961`

> Pays all queued rewards to their corresponding addresses




## *function* oracle

LongShortController.oracle() `view` `7dc0d1d0`





## *function* owner

LongShortController.owner() `view` `8da5cb5b`





## *function* openLongShort

LongShortController.openLongShort(parameterHash, currencyPair, duration, leverage, ownerSignatures, paymentAddresses, balances, isLongs) `payable` `914bcee9`

> LongShort opener function. Can only be called by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | parameterHash | Hash of the parameters, used in creating the unique LongShortHash |
| *bytes7* | currencyPair | A 7-character representation of a currency pair |
| *uint256* | duration | seconds to closing date from block.timestamp |
| *uint8* | leverage | A modifier which defines the rewards and the allowed price jump |
| *bytes32[]* | ownerSignatures | A list of bytes32 signatures for position owners |
| *address[]* | paymentAddresses | A list of addresses to be rewarded |
| *uint256[]* | balances | A list of original bet amounts |
| *bool[]* | isLongs | A list of position types {true: "LONG", false: "SHORT"} |


## *function* calculateReward

LongShortController.calculateReward(isLong, balance, leverage, startingPrice, closingPrice) `pure` `a3cfb754`

> Calculates reward for a single position with given parameters

Inputs

| | | |
|-|-|-|
| *bool* | isLong | {true: "LONG", false: "SHORT"} |
| *uint256* | balance | the balance to calculate a reward for |
| *uint8* | leverage | leverage of the LongShort |
| *uint256* | startingPrice | price fetched from the Oracle on creation |
| *uint256* | closingPrice | price fetched from the Oracle when this function was called |

Outputs

| | | |
|-|-|-|
| *uint256* | reward | Reward that is added to a payment pool |

## *function* oracleAddress

LongShortController.oracleAddress() `view` `a89ae4ba`





## *function* debugString

LongShortController.debugString(message) `nonpayable` `b6d929cf`

> Debug a string

Inputs

| | | |
|-|-|-|
| *string* | message | undefined |


## *function* getLongShortHashes

LongShortController.getLongShortHashes(closingDate) `view` `c83e2d4d`

> Get LongShort identifiers/hashes by closing date. Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *uint256* | closingDate | closing date to get LongShorts for |

Outputs

| | | |
|-|-|-|
| *bytes32[]* | hashes | Unique identifiers for the LongShorts expiring on the closingDate. |

## *function* getLongShort

LongShortController.getLongShort(longShortHash) `view` `cdc06c91`

> Get a single LongShort with its identifier Only callable by the owner.

Inputs

| | | |
|-|-|-|
| *bytes32* | longShortHash | unique identifier for a LongShort |

Outputs

| | | |
|-|-|-|
| *bytes32* | currencyPair | 7-character representation of a currency pair. For example, ETH-USD |
| *uint256* | startingPrice | self-explanatory |
| *uint8* | leverage | self-explanatory |

## *function* LEVERAGES

LongShortController.LEVERAGES() `view` `cf90f950`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* getRewardsLength

LongShortController.getRewardsLength() `view` `d7da1dee`

> Get the length of all queued rewards



Outputs

| | | |
|-|-|-|
| *uint256* | rewardsLength | number of rewards in queue |

## *function* validateLeverage

LongShortController.validateLeverage(leverage) `view` `d806476d`

> Helper function to restrict users from opening orders with any other than predefined leverages.

Inputs

| | | |
|-|-|-|
| *uint8* | leverage | an uint8 number |


## *function* toggleDebug

LongShortController.toggleDebug() `nonpayable` `ed998065`

> activates or deactivates the debug functionality.




## *function* transferOwnership

LongShortController.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |

## *event* DebugString

LongShortController.DebugString(message) `20670ef4`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |

## *event* DebugWithValue

LongShortController.DebugWithValue(message, value) `6e90aba1`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |
| *uint256* | value | not indexed |

## *event* OwnershipTransferred

LongShortController.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

Arguments

| | | |
|-|-|-|
| *address* | previousOwner | indexed |
| *address* | newOwner | indexed |


---
# Oracle

Convoluted Labs

## *function* price

Oracle.price() `view` `37612293`


Inputs

| | | |
|-|-|-|
| *bytes7* |  | undefined |


## *function* setLatestPrices

Oracle.setLatestPrices(_currencyPairs, _prices) `nonpayable` `5411e86b`

> Endpoint for the Oracle owner to update prices

Inputs

| | | |
|-|-|-|
| *bytes7[]* | _currencyPairs | undefined |
| *uint256[]* | _prices | undefined |


## *function* debugWithValue

Oracle.debugWithValue(message, value) `nonpayable` `5a47e57c`

> Debug a string with a value

Inputs

| | | |
|-|-|-|
| *string* | message | undefined |
| *uint256* | value | undefined |


## *function* owner

Oracle.owner() `view` `8da5cb5b`





## *function* debugString

Oracle.debugString(message) `nonpayable` `b6d929cf`

> Debug a string

Inputs

| | | |
|-|-|-|
| *string* | message | undefined |


## *function* timesUpdated

Oracle.timesUpdated() `view` `dd0f8d2d`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* pricesByTime

Oracle.pricesByTime(, ) `view` `e82d9a3e`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |
| *uint256* |  | undefined |


## *function* toggleDebug

Oracle.toggleDebug() `nonpayable` `ed998065`

> activates or deactivates the debug functionality.




## *function* transferOwnership

Oracle.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |

## *event* DebugString

Oracle.DebugString(message) `20670ef4`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |

## *event* DebugWithValue

Oracle.DebugWithValue(message, value) `6e90aba1`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |
| *uint256* | value | not indexed |

## *event* OwnershipTransferred

Oracle.OwnershipTransferred(previousOwner, newOwner) `8be0079c`

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

> Helper function to restrict users from opening orders with any other than predefined leverages.

Inputs

| | | |
|-|-|-|
| *uint8* | leverage | an uint8 number |


---