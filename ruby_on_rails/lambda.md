# lambda

[stabby lambda](https://isotope11.com/blog/stabby-lambda)

```Ruby
a = lambda {p 'Hello World'}
a.call
# equals to
a = -> {p 'Hello World'}
a.call
```
