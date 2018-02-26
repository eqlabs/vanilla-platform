* [Debuggable](#debuggable)
  * [debugWithValue](#function-debugwithvalue)
  * [owner](#function-owner)
  * [debugString](#function-debugstring)
  * [toggleDebug](#function-toggledebug)
  * [transferOwnership](#function-transferownership)
  * [DebugString](#event-debugstring)
  * [DebugWithValue](#event-debugwithvalue)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Oracle](#oracle)
  * [debugWithValue](#function-debugwithvalue)
  * [owner](#function-owner)
  * [latestPrice](#function-latestprice)
  * [debugString](#function-debugstring)
  * [timesUpdated](#function-timesupdated)
  * [toggleDebug](#function-toggledebug)
  * [transferOwnership](#function-transferownership)
  * [priceByTime](#function-pricebytime)
  * [setLatestPrice](#function-setlatestprice)
  * [DebugString](#event-debugstring)
  * [DebugWithValue](#event-debugwithvalue)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Ownable](#ownable)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)

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
# Oracle

Convoluted Labs

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





## *function* latestPrice

Oracle.latestPrice() `view` `a3e6ba94`





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