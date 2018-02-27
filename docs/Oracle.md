* [Oracle](#oracle)
  * [price](#function-price)
  * [setLatestPrices](#function-setlatestprices)
  * [owner](#function-owner)
  * [timesUpdated](#function-timesupdated)
  * [pricesByTime](#function-pricesbytime)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)
* [Ownable](#ownable)
  * [owner](#function-owner)
  * [transferOwnership](#function-transferownership)
  * [OwnershipTransferred](#event-ownershiptransferred)

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


## *function* owner

Oracle.owner() `view` `8da5cb5b`





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


## *function* transferOwnership

Oracle.transferOwnership(newOwner) `nonpayable` `f2fde38b`

> Allows the current owner to transfer control of the contract to a newOwner.

Inputs

| | | |
|-|-|-|
| *address* | newOwner | The address to transfer ownership to. |

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