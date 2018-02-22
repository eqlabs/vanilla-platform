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