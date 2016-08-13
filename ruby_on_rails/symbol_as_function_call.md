# Symbol as method calls

[Understanding Ruby symbol as method call [duplicate]](http://stackoverflow.com/questions/14736452/understanding-ruby-symbol-as-method-call)

```Ruby
def abc
  p "Hello World!"
end

abc
# equals to
send(:abc)
```