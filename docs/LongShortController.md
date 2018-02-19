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
* [Ownable](#ownable)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [SafeMath](#safemath)

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