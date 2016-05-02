# Java

## Math

* `Math.max(T a, T b)`
* `Math.min(T a, T b)`
* `Math.abs(T a)`

* Integer.MAX_VALUE
* Integer.MIN_VALUE

### Parse string to integer with specific radix

[docs](http://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html#parseInt-java.lang.String-int-)

* public static int parseInt(String s, int radix)
```java
parseInt("0", 10) returns 0
parseInt("473", 10) returns 473
parseInt("+42", 10) returns 42
parseInt("-0", 10) returns 0
parseInt("-FF", 16) returns -255
parseInt("1100110", 2) returns 102
parseInt("2147483647", 10) returns 2147483647
parseInt("-2147483648", 10) returns -2147483648
parseInt("2147483648", 10) throws a NumberFormatException
parseInt("99", 8) throws a NumberFormatException
parseInt("Kona", 10) throws a NumberFormatException
parseInt("Kona", 27) returns 411787
```

## String manipulation

* contains(CharSequence s)
* indexOf(int ch)
* indexOf(int ch, int fromIndex)
* indexOf(String str)
* indexOf(String str, int fromIndex)
* matches(String regex)
* startsWith(String prefix)
* substring(int beginIndex)
* substring(int beginIndex, int endIndex): [begin, end)
* toCharArray()
* valueOf(T val)

### String trim

[docs](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#trim--)
```java
String a = "   abc   ";
a.trim();  // returns "abc"
```

### String Split

[Java 8 docs](http://docs.oracle.com/javase/8/docs/api/java/lang/String.html#split-java.lang.String-)

```
public String[] split(String regex)
```
```
:	{ "boo", "and", "foo" }
o	{ "b", "", ":and:f" }
```

### String Join

[Java 8 docs](http://docs.oracle.com/javase/8/docs/api/java/lang/String.html#join-java.lang.CharSequence-java.lang.CharSequence...-)

```java
public static String join(CharSequence delimiter, CharSequence... elements)
public static String join(CharSequence delimiter, Iterable<? extends CharSequence> elements)
```
```java
String message = String.join("-", "Java", "is", "cool");
// message returned is: "Java-is-cool"

List<String> strings = new LinkedList<>();
strings.add("Java");strings.add("is");
strings.add("cool");
String message = String.join(" ", strings);
//message returned is: "Java is cool"

Set<String> strings = new LinkedHashSet<>();
strings.add("Java"); strings.add("is");
strings.add("very"); strings.add("cool");
String message = String.join("-", strings);
//message returned is: "Java-is-very-cool"
```

### Regular expression

```java
String num = "02-2244335, 04-7255715, 03-394829";
Pattern p = Pattern.compile("(\\d{2})-(\\d*)");
Matcher m = p.matcher(num);
while(m.find()) {
    System.out.println(m.group(0));  // group 0 represented the whole matching string
    System.out.println(m.group(1));
    System.out.println(m.group(2));
}
```

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

#### TreeSet

[docs](https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html)

Methods:
* `E floor(E e)`: Returns the greatest element in this set less than or equal to the given element, or null if there is no such element.
* `E ceiling(E e)`: Returns the least element in this set greater than or equal to the given element, or null if there is no such element.

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
	* Behavior: Associates the specified value with the specified key in this map (optional operation). If the map previously contained a mapping for the key, the old value is replaced by the specified value. (A map m is said to contain a mapping for a key k if and only if m.containsKey(k) would return true.)
	* Returns: the previous value associated with key, or null if there was no mapping for key. (A null return can also indicate that the map previously associated null with key, if the implementation supports null values.)
* `putAll(Map<? extends K,? extends V> m)`
* `get(Object key)`: null if this map contains no mapping for the key
* `getOrDefault(Object key, V defaultValue)`: Returns the value to which the specified key is mapped, or defaultValue if this map contains no mapping for the key.
* `remove(Object key)`
* `remove(Object key, Object value)`: Removes the entry for the specified key only if it is currently mapped to the specified value.
* `Set<Map.Entry<K,V>>	entrySet()`: Returns a Set view of the mappings contained in this map.


* `clear()`
* `containsKey(Object key)`
* `containsValue(Object value)`
* `isEmpty()`
* `Set<K> keySet()`: Returns a Set view of the keys contained in this map.
* `Collection<V> values()`: Returns a Collection view of the values contained in this map.

Iterate over a map
[so discussion](http://stackoverflow.com/questions/15422428/iterator-over-hashmap-in-java)
[blog](http://www.sergiy.ca/how-to-iterate-over-a-map-in-java/)
```java
Map<Integer, Integer> map = new HashMap<Integer, Integer>();
for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
    System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
}
```

Iterate over a map using lambda
```java
Map<Integer, Integer> map = new HashMap<Integer, Integer>();
map.forEach((k, v) -> {
	System.out.println("Key = " + entry.getKey() + ", Value = " + entry.getValue());
});
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

```java
public class ArrayDeque<E>
extends AbstractCollection<E>
implements Deque<E>, Cloneable, Serializable
```

Resizable-array implementation of the Deque interface. Array deques have no capacity restrictions; they grow as necessary to support usage. They are not thread-safe; in the absence of external synchronization, they do not support concurrent access by multiple threads. Null elements are prohibited. This class is likely to be faster than Stack when used as a stack, and faster than LinkedList when used as a queue.

### Stack

[docs](https://docs.oracle.com/javase/7/docs/api/java/util/Stack.html)

A more complete and consistent set of LIFO stack operations is provided by the Deque interface and its implementations, which should be used in preference to this class. For example:

`Deque<Integer> stack = new ArrayDeque<Integer>();`

### PriorityQueue

`java.util.PriorityQueue<E>`

All Implemented Interfaces: Serializable, Iterable<E>, Collection<E>, Queue<E>

[docs](https://docs.oracle.com/javase/8/docs/api/java/util/PriorityQueue.html)

* `PriorityQueue()`
* `PriorityQueue(Collection<? extends E> c)`: Creates a PriorityQueue containing the elements in the specified collection.
* `PriorityQueue(Comparator<? super E> comparator)`: Creates a PriorityQueue with the default initial capacity and whose elements are ordered according to the specified comparator.

* contains(Object o)
* offer(E e)
* peek()
* poll()
* remove(Object o)
* size()

## Arrays and Collections

### Misc
* `Arrays.equals(T[] a1, T[] a2)`: T is overloading for all types.
* `Arrays.deepEquals(Object[] a1, Object[] a2)`: Returns true if the two specified arrays are deeply equal to one another.

### Fill

* `java.util.Arrays.fill(T[] a, T val)`
* `java.util.Arrays.fill(T[] a, int fromIndex, int toIndex, T val)`
* `java.util.Collections.fill(List<? super T> list, T obj)`

### Binary Search

* `java.util.Arrays.binarySearch(T[] a, T key)`
* `java.util.Arrays.binarySearch(T[] a, int fromIndex, int toIndex, T key)`
* `java.util.Arrays.binarySearch(T[] a, T key, Comparator<? super T> c)`
* `java.util.Arrays.binarySearch(T[] a, int fromIndex, int toIndex, T key, Comparator<? super T> c)`
* `java.util.Collections.binarySearch(List<? extends Comparable<? super T>> list, T key)`
* `java.util.Collections.binarySearch(List<? extends T> list, T key, Comparator<? super T> c)`

Returns:
the index of the search key, if it is contained in the list; otherwise, (-(insertion point) - 1). The insertion point is defined as the point at which the key would be inserted into the list: the index of the first element greater than the key, or list.size() if all elements in the list are less than the specified key. Note that this guarantees that the return value will be >= 0 if and only if the key is found.

Insertion point can be get by `~returnValue`

```java
int position = Arrays.binarySearch(sum, prev + s);
position = position > 0 ? position : ~position;
```

### Sort

Java sort is stable sort. Most implementation use MergeSort.

* `java.util.Arrays.sort(T[] a)`
* `java.util.Arrays.sort(T[] a, int fromIndex, int toIndex)`
* `java.util.Arrays.sort(T[] a, Comparator<? super T> c)`
* `java.util.Arrays.sort(T[] a, int fromIndex, int toIndex, Comparator<? super T> c)`

* `java.util.Collections.sort(List<T> list)`
* `java.util.Collections.sort(List<T> list, Comparator<? super T> c)`

```java
// default sort
Collections.sort(list);

// reverseOrder
Collections.sort(list, Comparator.reverseOrder());

// custom comparator
Collections.sort(list, new Comparator<Integer>() {
    @Override
    public int compare(Integer a, Integer b) {
        return b - a;
    }
});

// Using lambda
Collections.sort(list, (a, b) -> b - a);

// Comparator as variable
Comparator<Integer> comp = (a, b) -> b - a;
Collections.sort(list, comp);

// custom type with lambda comparator
static private class Node {
    int x, y;
    public String toString() { return String.format("(x: %d, y: %d)", x, y);}
}

static private void sortNode() {
    Node[] arr = new Node[NUM];
    Random rdm = new Random();
    for(int i = 0; i < NUM; i++) {
        arr[i] = new Node();
        arr[i].x = rdm.nextInt(100);
        arr[i].y = rdm.nextInt(100);
    }
    Comparator<Node> compX = (a, b) -> a.x - b.x;
    Comparator<Node> compY = (a, b) -> a.y - b.y;
    Arrays.sort(arr, compX);
    System.out.println(Arrays.asList(arr));
    Arrays.sort(arr, compY);
    System.out.println(Arrays.asList(arr));
}
```
