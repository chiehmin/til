## Rounding to zero vs Rounding to negative

C/C++ and Java choose rounding to zero. Python and Ruby choose rounding to negative.

In C/C++ and Java
`-1 / 10` returns `0`

In Python and Ruby
`-1 / 10` returns `-1`

[so disscussion](http://stackoverflow.com/questions/19517868/integer-division-by-negative-number)

## Modulus vs Remainder

In python
`-1 % 10` returns `9`

In C/C++ and Java
`-1 % 10` returns `-1`

Modulus always returns positive number, however remainder may return negative number.

In Python the % operator returns the modulus and in Java it returns the remainder

[so disscussion1](http://stackoverflow.com/questions/5385024/mod-in-java-produces-negative-numbers)
[so disscussion2](http://stackoverflow.com/questions/13683563/whats-the-difference-between-mod-and-remainder)