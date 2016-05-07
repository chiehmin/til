# Operator overloading

## Implementing as member functions vs non-member functions

[so](http://stackoverflow.com/questions/4622330/operator-overloading-member-function-vs-non-member-function)

If you define your operator overloaded function as member function, then compiler translates expressions like s1 + s2 into s1.operator+(s2).

There's a major problem if we want to overload an operator where the first operand is not a class type

```c++
class Sample
{
 public:
    Sample operator + (const Sample& op2); //works with s1 + s2
    Sample operator + (double op2); //works with s1 + 10.0

   //Make it `friend` only when it needs to access private members.
   //Otherwise simply make it **non-friend non-member** function.
    friend Sample operator + (double op1, const Sample& op2); //works with 10.0 + s2
}
```
