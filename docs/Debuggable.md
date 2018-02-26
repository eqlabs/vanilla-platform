* [Debuggable](#debuggable)
  * [debugWithValue](#function-debugwithvalue)
  * [owner](#function-owner)
  * [debugString](#function-debugstring)
  * [toggleDebug](#function-toggledebug)
  * [transferOwnership](#function-transferownership)
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