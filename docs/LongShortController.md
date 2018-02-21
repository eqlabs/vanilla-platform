* [Debuggable](#debuggable)
  * [debug](#function-debug)
  * [DebugEvent](#event-debugevent)
* [LongShortController](#longshortcontroller)
  * [getActiveClosingDates](#function-getactiveclosingdates)
  * [debug](#function-debug)
  * [linkOracle](#function-linkoracle)
  * [payRewards](#function-payrewards)
  * [oracle](#function-oracle)
  * [owner](#function-owner)
  * [oracleAddress](#function-oracleaddress)
  * [exercise](#function-exercise)
  * [getPaymentsLength](#function-getpaymentslength)
  * [openLongShort](#function-openlongshort)
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


Inputs

| | | |
|-|-|-|
| *address* | _oracleAddress | undefined |


## *function* payRewards

LongShortController.payRewards() `nonpayable` `7288e961`





## *function* oracle

LongShortController.oracle() `view` `7dc0d1d0`





## *function* owner

LongShortController.owner() `view` `8da5cb5b`





## *function* oracleAddress

LongShortController.oracleAddress() `view` `a89ae4ba`





## *function* exercise

LongShortController.exercise(closingDate) `nonpayable` `b07f0a41`


Inputs

| | | |
|-|-|-|
| *uint256* | closingDate | undefined |


## *function* getPaymentsLength

LongShortController.getPaymentsLength() `view` `b8e0ffbe`





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