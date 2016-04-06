# Java

## Math

* `Math.max(T a, T b)`
* `Math.min(T a, T b)`
* `Math.abs(T a)`

* Integer.MAX_VALUE
* Integer.MIN_VALUE

## Misc

### Convert from Integer to String

* `String.valueOf(number)`
* `number + ""`
* `Integer.toString(number)`

## Data Strutures

### Set

[docs](https://docs.oracle.com/javase/8/docs/api/java/util/Set.html)

Implementing classes:
...`HashSet`, `TreeSet`...

Methods:
* `add(E e)`
* `addAll(Collection<? extends E> c)`
* `contains(Object o)`
* `containsAll(Collection<?> c)`
* `isEmpty()`
* `remove(Object o)`
* `removeAll(Collection<?> c)`
* `retainAll(Collection<?> c)`: set intersection
* `size()`
* `toArray()`

### Map

[docs](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html)

Nested class:
```java
static interface 	Map.Entry<K,V>
// A map entry (key-value pair).
```
* `getKey()`
* `getValue()`
* `setValue(V value)`

Implementing classes:
...`HashMap`, `HashTable`, `TreeMap`...

[HashMap vs HashTable](http://stackoverflow.com/questions/40471/differences-between-hashmap-and-hashtable)

Hashtable is synchronized, whereas HashMap is not. This makes HashMap better for non-threaded applications, as unsynchronized Objects typically perform better than synchronized ones.

Methods:
* `put(K key, V value)`
* `putAll(Map<? extends K,? extends V> m)`
* `get(Object key)`
* `getOrDefault(Object key, V defaultValue)`: Returns the value to which the specified key is mapped, or defaultValue if this map contains no mapping for the key.
* `remove(Object key)`
* `remove(Object key, Object value)`: Removes the entry for the specified key only if it is currently mapped to the specified value.
* `Set<Map.Entry<K,V>>	entrySet()`: Returns a Set view of the mappings contained in this map.


* `clear()`
* `containsKey(Object key)`
* `containsValue(Object value)`
* `isEmpty()`
* `keySet()`

Iterate over a map
[so discussion](http://stackoverflow.com/questions/15422428/iterator-over-hashmap-in-java)
[blog](http://www.sergiy.ca/how-to-iterate-over-a-map-in-java/)
```java
Map<Integer, Integer> map = new HashMap<Integer, Integer>();
for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
    System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
}
```

### Queue

[docs](https://docs.oracle.com/javase/7/docs/api/java/util/Queue.html)

`public interface Queue<E> extends Collection<E>`

Known Implementing Classes:
* ... LinkedList ...

|          |  Throws exception |  Returns special value | 
|----------|-------------------|------------------------|
|  Insert  |  add(e)           |  offer(e)              |
|  Remove  |  remove()         |  poll()                |
|  Examine |  element()        |  peek()                |

### Deque

[docs](https://docs.oracle.com/javase/7/docs/api/java/util/Deque.html)

`public interface Deque<E> extends Queue<E>`

* `offer(E e)`
* `offerFirst(E e)`
* `offerLast(E e)`
* `peek()`
* `peekFirst()`
* `peekLast()`
* `poll()`
* `pollFirst()`
* `pollLast()`

#### Stack Operation
* `push(e)`: `addFirst(e)`
* `pop()`: `removeFirst()`
* `peek()`: `peekFirst()`

#### Queue Operation
* `offer(e)`: `offerLast(e)`
* `poll()`: `pollFirst()`
* `peek()`: `peekFirst()`

#### Linkedlist

[docs](https://docs.oracle.com/javase/7/docs/api/java/util/LinkedList.html)

```java
public class LinkedList<E>
extends AbstractSequentialList<E>
implements List<E>, Deque<E>, Cloneable, Serializable
```

#### ArrayDeque

[docs](https://docs.oracle.com/javase/7/docs/api/java/util/ArrayDeque.html)

```
public class ArrayDeque<E>
extends AbstractCollection<E>
implements Deque<E>, Cloneable, Serializable
```

Resizable-array implementation of the Deque interface. Array deques have no capacity restrictions; they grow as necessary to support usage. They are not thread-safe; in the absence of external synchronization, they do not support concurrent access by multiple threads. Null elements are prohibited. This class is likely to be faster than Stack when used as a stack, and faster than LinkedList when used as a queue.

## Stack

[docs](https://docs.oracle.com/javase/7/docs/api/java/util/Stack.html)

A more complete and consistent set of LIFO stack operations is provided by the Deque interface and its implementations, which should be used in preference to this class. For example:

`Deque<Integer> stack = new ArrayDeque<Integer>();`

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