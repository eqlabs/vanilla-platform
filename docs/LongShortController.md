* [Debuggable](#debuggable)
  * [debug](#function-debug)
  * [DebugEvent](#event-debugevent)
* [LongShortController](#longshortcontroller)
  * [requireZeroSum](#function-requirezerosum)
  * [activeClosingDates](#function-activeclosingdates)
  * [getActiveClosingDates](#function-getactiveclosingdates)
  * [debug](#function-debug)
  * [linkOracle](#function-linkoracle)
  * [payRewards](#function-payrewards)
  * [openLongShort](#function-openlongshort)
  * [oracle](#function-oracle)
  * [owner](#function-owner)
  * [calculateReward](#function-calculatereward)
  * [oracleAddress](#function-oracleaddress)
  * [exercise](#function-exercise)
  * [getLongShortHashes](#function-getlongshorthashes)
  * [getLongShort](#function-getlongshort)
  * [LEVERAGES](#function-leverages)
  * [getRewardsLength](#function-getrewardslength)
  * [validateLeverage](#function-validateleverage)
  * [transferOwnership](#function-transferownership)
  * [DebugEvent](#event-debugevent)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Oracle](#oracle)
  * [debug](#function-debug)
  * [owner](#function-owner)
  * [latestPrice](#function-latestprice)
  * [timesUpdated](#function-timesupdated)
  * [transferOwnership](#function-transferownership)
  * [priceByTime](#function-pricebytime)
  * [setLatestPrice](#function-setlatestprice)
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





## *function* debug

LongShortController.debug(message) `nonpayable` `2f50fbfa`

> Debug function that gets injected to extending contracts

Inputs

| | | |
|-|-|-|
| *string* | message | the message that we want to log/debug |


## *function* linkOracle

LongShortController.linkOracle(_oracleAddress) `nonpayable` `6b7ef2ee`

> Links Vanilla's oracle to the contract

Inputs

| | | |
|-|-|-|
| *address* | _oracleAddress | undefined |


## *function* payRewards

LongShortController.payRewards() `nonpayable` `7288e961`





## *function* openLongShort

LongShortController.openLongShort(parameterHash, currencyPair, duration, leverage, ownerSignatures, paymentAddresses, balances, isLongs) `payable` `750614c7`

> LongShort activator function. Called by OrdersManager.

Inputs

| | | |
|-|-|-|
| *bytes32* | parameterHash | undefined |
| *bytes32* | currencyPair | undefined |
| *uint256* | duration | undefined |
| *uint8* | leverage | undefined |
| *bytes32[]* | ownerSignatures | undefined |
| *address[]* | paymentAddresses | undefined |
| *uint256[]* | balances | undefined |
| *bool[]* | isLongs | undefined |


## *function* oracle

LongShortController.oracle() `view` `7dc0d1d0`





## *function* owner

LongShortController.owner() `view` `8da5cb5b`





## *function* calculateReward

LongShortController.calculateReward(isLong, balance, leverage, startingPrice, closingPrice) `pure` `a3cfb754`


Inputs

| | | |
|-|-|-|
| *bool* | isLong | undefined |
| *uint256* | balance | undefined |
| *uint8* | leverage | undefined |
| *uint256* | startingPrice | undefined |
| *uint256* | closingPrice | undefined |


## *function* oracleAddress

LongShortController.oracleAddress() `view` `a89ae4ba`





## *function* exercise

LongShortController.exercise(longShortHash) `nonpayable` `c6daf4eb`


Inputs

| | | |
|-|-|-|
| *bytes32* | longShortHash | undefined |


## *function* getLongShortHashes

LongShortController.getLongShortHashes(closingDate) `view` `c83e2d4d`


Inputs

| | | |
|-|-|-|
| *uint256* | closingDate | undefined |


## *function* getLongShort

LongShortController.getLongShort(longShortHash) `view` `cdc06c91`


Inputs

| | | |
|-|-|-|
| *bytes32* | longShortHash | undefined |


## *function* LEVERAGES

LongShortController.LEVERAGES() `view` `cf90f950`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* getRewardsLength

LongShortController.getRewardsLength() `view` `d7da1dee`





## *function* validateLeverage

LongShortController.validateLeverage(leverage) `view` `d806476d`


Inputs

| | | |
|-|-|-|
| *uint8* | leverage | undefined |


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
# Oracle

Convoluted Labs

## *function* debug

Oracle.debug(message) `nonpayable` `2f50fbfa`

> Debug function that gets injected to extending contracts

Inputs

| | | |
|-|-|-|
| *string* | message | the message that we want to log/debug |


## *function* owner

Oracle.owner() `view` `8da5cb5b`





## *function* latestPrice

Oracle.latestPrice() `view` `a3e6ba94`





## *function* timesUpdated

Oracle.timesUpdated() `view` `dd0f8d2d`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* transferOwnership

Oracle.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |


## *function* priceByTime

Oracle.priceByTime() `view` `f3b4c89a`


Inputs

| | | |
|-|-|-|
| *uint256* |  | undefined |


## *function* setLatestPrice

Oracle.setLatestPrice(_latestPrice) `nonpayable` `fc9bb7fe`

> Endpoint for the Oracle owner to update prices

Inputs

| | | |
|-|-|-|
| *uint256* | _latestPrice | The latest price from Vanilla API |


## *event* DebugEvent

Oracle.DebugEvent(message) `56f074d2`

Arguments

| | | |
|-|-|-|
| *string* | message | not indexed |

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


Inputs

| | | |
|-|-|-|
| *uint8* | leverage | undefined |


---