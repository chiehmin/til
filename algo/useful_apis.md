# Java

## Math

* `Math.max(T a, T b)`
* `Math.min(T a, T b)`
* `Math.abs(T a)`

## Binary Search

`java.util.Arrays.binarySearch(T[] a, T key)`
`java.util.Collections.binarySearch(List<? extends Comparable<? super T>> list, T key)`
`java.util.Collections.binarySearch(List<? extends T> list, T key, Comparator<? super T> c)`

Returns:
the index of the search key, if it is contained in the list; otherwise, (-(insertion point) - 1). The insertion point is defined as the point at which the key would be inserted into the list: the index of the first element greater than the key, or list.size() if all elements in the list are less than the specified key. Note that this guarantees that the return value will be >= 0 if and only if the key is found.

Insertion point can be get by `~returnValue`

```java
int position = Arrays.binarySearch(sum, prev + s);
position = position > 0 ? position : ~position;
```