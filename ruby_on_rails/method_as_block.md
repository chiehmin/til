# Method as block

[How to pass a function instead of a block](http://stackoverflow.com/questions/13945503/how-to-pass-a-function-instead-of-a-block)

```Ruby
def inc(a)
  a+1
end
p [1,2,3].map(&method(:inc))
```
```Ruby
class Integer
  def inc
    self + 1
  end
end

p [1,2,3].map(&:inc)
```

[so](http://stackoverflow.com/questions/9429819/what-is-the-functionality-of-operator-in-ruby)
[apidoc](http://apidock.com/rails/Symbol/to_proc)

```Ruby
# The same as people.collect { |p| p.name }
people.collect(&:name)

# The same as people.select { |p| p.manager? }.collect { |p| p.salary }
people.select(&:manager?).collect(&:salary)
```