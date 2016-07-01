# JavaFX Collections

[Learning JavaFX Collections](http://docs.oracle.com/javafx/2/collections/jfxpub-collections.htm)

Collections in JavaFX are defined by the javafx.collections package, which consists of the following interfaces and classes:

**Interfaces**
* ObservableList: A list that enables listeners to track changes when they occur
* ListChangeListener: An interface that receives notifications of changes to an ObservableList
* ObservableMap: A map that enables observers to track changes when they occur
* MapChangeListener: An interface that receives notifications of changes to an ObservableMap

**Classes**
* FXCollections: A utility class that consists of static methods that are one-to-one copies of java.util.Collections methods
* ListChangeListener.Change: Represents a change made to an ObservableList
* MapChangeListener.Change: Represents a change made to an ObservableMap

The javafx.collections.ObservableList and javafx.collections.ObservableMap interfaces both extend javafx.beans.Observable (and java.util.List or java.util.Map, respectively) to provide a List or Map that supports observability.

The most important point to remember is that a ListChangeListener.Change object can contain multiple changes, and therefore must be iterated by calling its next() method in a while loop. Note, however, that MapChangeListener.Change objects will only contain a change that represents the put or remove operation that was performed.

```java
List<String> list = new ArrayList<String>();

ObservableList<String> observableList = FXCollections.observableList(list);
observableList.addListener(new ListChangeListener() {

    @Override
    public void onChanged(ListChangeListener.Change change) {
        System.out.println("Detected a change! ");
        while (change.next()) {
            System.out.println("Was added? " + change.wasAdded());
            System.out.println("Was removed? " + change.wasRemoved());
            System.out.println("Was replaced? " + change.wasReplaced());
            System.out.println("Was permutated? " + change.wasPermutated());
            }
        }
    }
});
```
