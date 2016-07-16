# Using JavaFX Properties and Binding

[Using JavaFX Properties and Binding](http://docs.oracle.com/javafx/2/binding/jfxpub-binding.htm)

JavaFX properties are often used in conjunction with binding, a powerful mechanism for expressing direct relationships between variables. When objects participate in bindings, changes made to one object will automatically be reflected in another object.

Bindings are assembled from one or more sources, known as dependencies. A binding observes its list of dependencies for changes, and then updates itself automatically after a change has been detected.

#### Understanding Properties (JavaBeans)

The Java programming language makes it possible to encapsulate data within an object, but it does not enforce any specific naming conventions for the methods that you define.  In JavaBeans programming, the full signatures for these methods would be: public void setFirstName(String name), public String getFirstName(), public void setLastName(String name), and public String getLastName(). This naming pattern is easily recognizable, both to human programmers and to editing tools, such as the NetBeans IDE. In JavaBeans terminology, the Person object is said to contain firstName and lastName properties.

The JavaBeans model also provides support for complex property types, plus an event delivery system. It also contains a number of support classes, all available as an API under the java.beans package.

```java
package propertydemo;

import javafx.beans.property.DoubleProperty;
import javafx.beans.property.SimpleDoubleProperty;
 
class Bill {
 
    // Define a variable to store the property
    private DoubleProperty amountDue = new SimpleDoubleProperty();
 
    // Define a getter for the property's value
    public final double getAmountDue(){return amountDue.get();}
 
    // Define a setter for the property's value
    public final void setAmountDue(double value){amountDue.set(value);}
 
     // Define a getter for the property itself
    public DoubleProperty amountDueProperty() {return amountDue;}
 
}
```

A new wrapper class that encapsulates a Java primitive and adds some extra functionality (the classes under javafx.beans.property all contain built-in support for observability and binding as part of their design).

```java
package propertydemo;
 
import javafx.beans.value.ObservableValue;
import javafx.beans.value.ChangeListener;
 
public class Main {
 
    public static void main(String[] args) {
 
      Bill electricBill = new Bill();
 
       electricBill.amountDueProperty().addListener(new ChangeListener(){
        @Override public void changed(ObservableValue o,Object oldVal, 
                 Object newVal){
             System.out.println("Electric bill has changed!");
        }
      });
     
      electricBill.setAmountDue(100.00);
     
    }
}
```