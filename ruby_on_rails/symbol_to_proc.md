# Symbol to proc

[so](http://stackoverflow.com/questions/9429819/what-is-the-functionality-of-operator-in-ruby)
[apidoc](http://apidock.com/rails/Symbol/to_proc)

```Ruby
# The same as people.collect { |p| p.name }
people.collect(&:name)

# The same as people.select { |p| p.manager? }.collect { |p| p.salary }
people.select(&:manager?).collect(&:salary)
```