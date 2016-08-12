# Setters and Getters

[Setters and Getters in Ruby](https://www.quora.com/What-are-setters-and-getters-in-Ruby)

```Ruby
class Car
  def velocity
    @velocity
  end
 
  def velocity=(new_velocity)
    @velocity = new_velocity
  end
end
```

```Ruby
class Car
  attr_reader :velocity
  attr_writer :velocity
end
```

```Ruby
class Car
  attr_accessor :velocity
end
```