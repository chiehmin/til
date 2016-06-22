# Rvalue reference

[range-based for using rvalue ref](http://stackoverflow.com/questions/13130708/what-is-the-advantage-of-using-universal-references-in-range-based-for-loops)
[Return value optimization](https://en.wikipedia.org/wiki/Return_value_optimization)
[C++ rvalue reference](http://shininglionking.blogspot.tw/2013/06/c-rvalue-reference.html)
[A Brief Introduction to Rvalue References](http://www.artima.com/cppsource/rvalue.html)

```cpp
A a;
A& a_ref1 = a;  // an lvalue reference

A a;
A&& a_ref2 = a;  // an rvalue reference

A&  a_ref3 = A();  // Error!
A&& a_ref4 = A();  // Ok
```

## std::move

[http://www.360doc.com/content/14/0118/23/9200790_346303793.shtml](http://www.360doc.com/content/14/0118/23/9200790_346303793.shtml)
[C++11 Tutorial: Introducing the Move Constructor and the Move Assignment Operator](http://blog.smartbear.com/c-plus-plus/c11-tutorial-introducing-the-move-constructor-and-the-move-assignment-operator/)

```cpp
string func()
{
    string s;
    //do something with s
    return s;
}
string mystr=func();

/*
When func() returns, C++ constructs a temporary copy of s on the caller’s stack memory. Next, s is destroyed and the temporary is used for copy-constructing mystr. After that, the temporary itself is destroyed. Moving achieves the same effect without so many copies and destructor calls along the way.
*/
```