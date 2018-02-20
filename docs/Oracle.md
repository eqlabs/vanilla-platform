* [Debuggable](#debuggable)
  * [debug](#function-debug)
  * [DebugEvent](#event-debugevent)
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


Inputs

| | | |
|-|-|-|
| *uint256* | _latestPrice | undefined |


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