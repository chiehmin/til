# Useful api

### Input and Output
```ruby
# stdin
n = gets.to_i
arr = gets.split.map(&:to_i)

# stdout
printf("%d %.2f %s\n", 1, 99.3, "Justin")
x = "%d %.2f %s" % [1, 99.3, "Justin"]

# File Input
file = open("5566.txt", "r")
line = file.gets
# or
open("5566.txt", "r") do |file|
    file.each do |line|
        print line
    end
end
```

### Slice
```ruby
array[index]                # -> obj      or nil
array[start, length]        # -> an_array or nil
array[range]                # -> an_array or nil
array.slice(index)          # -> obj      or nil
array.slice(start, length)  # -> an_array or nil
array.slice(range)          # -> an_array or nil

# Example
a = [ "a", "b", "c", "d", "e" ]
a[2] +  a[0] + a[1]    #=> "cab"
a[6]                   #=> nil
a[1, 2]                #=> [ "b", "c" ]
a[1..3]                #=> [ "b", "c", "d" ]
a[4..7]                #=> [ "e" ]
a[6..10]               #=> nil
a[-3, 3]               #=> [ "c", "d", "e" ]
# special cases
a[5]                   #=> nil
a[5, 1]                #=> []
a[5..10]               #=> []
```

### Join
```ruby
[ "a", "b", "c" ].join        #=> "abc"
[ "a", "b", "c" ].join("-")   #=> "a-b-c"
[ 1, 2, 3 ] * ","  #=> "1,2,3"
```