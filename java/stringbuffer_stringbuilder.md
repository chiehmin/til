# StringBuffer vs StringBuilder

The StringBuffer and StringBuilder classes are used when there is a necessity to make a lot of modifications to Strings of characters.

Difference between StringBuffer and StringBuilder

* StringBuffer is thread-safe
* StringBuilder is not thread-safe. StringBuilder is faster than StringBuffer

## StringBuffer methods

[docs](https://docs.oracle.com/javase/7/docs/api/java/lang/StringBuffer.html)

* `public StringBuffer append(String s)`
* `public StringBuffer reverse()`
* `public delete(int start, int end)`
* `public insert(int offset, String str)`
* `replace(int start, int end, String str)`