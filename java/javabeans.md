# JavaBeans

[Oracle JavaBeans tutorial](https://docs.oracle.com/javase/tutorial/javabeans/)
[wiki](https://en.wikipedia.org/wiki/JavaBeans)

In computing based on the Java Platform, JavaBeans are classes that encapsulate many objects into a single object (the bean). They are serializable, have a zero-argument constructor, and allow access to properties using getter and setter methods. The name "Bean" was given to encompass this standard, which aims to create reusable software components for Java.

The Java programming language makes it possible to encapsulate data within an object, but it does not enforce any specific naming conventions for the methods that you define.  In JavaBeans programming, the full signatures for these methods would be: public void setFirstName(String name), public String getFirstName(), public void setLastName(String name), and public String getLastName(). This naming pattern is easily recognizable, both to human programmers and to editing tools, such as the NetBeans IDE. In JavaBeans terminology, the Person object is said to contain firstName and lastName properties.

The JavaBeans model also provides support for complex property types, plus an event delivery system. It also contains a number of support classes, all available as an API under the java.beans package.
