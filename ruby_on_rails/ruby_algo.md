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
## Array
### Iterating over Arrays
```ruby
# Traverse
arr = [1, 2, 3, 4, 5]
5.times { |i| puts arr[i] }
arr.each { |val| puts val }
arr.each_with_index { |val, idx| puts "arr[#{idx}] = #{val}" }
arr.reverse_each { |val| puts val }
arr.reverse.each_with_index { |val, idx| puts "arr[#{idx}] = #{val}" }

# Map
arr.map { |a| 2*a }   #=> [2, 4, 6, 8, 10]
arr                   #=> [1, 2, 3, 4, 5]
arr.map! { |a| a**2 } #=> [1, 4, 9, 16, 25]
arr                   #=> [1, 4, 9, 16, 25]

# Filter
arr = [1, 2, 3, 4, 5, 6]
arr.select { |a| a > 3 }     #=> [4, 5, 6]
arr.reject { |a| a < 3 }     #=> [3, 4, 5, 6]
```

### Adding Items to Arrays
```ruby
# push
arr = [1, 2, 3, 4]
arr.push(5) #=> [1, 2, 3, 4, 5]
arr << 6    #=> [1, 2, 3, 4, 5, 6]

# push front
arr.unshift(0) #=> [0, 1, 2, 3, 4, 5, 6]

# insert
arr.insert(3, 'apple')  #=> [0, 1, 2, 'apple', 3, 4, 5, 6]
```

### Removing Items from an Array
```ruby
# pop
arr =  [1, 2, 3, 4, 5, 6]
arr.pop #=> 6
arr #=> [1, 2, 3, 4, 5]

# pop front
arr.shift #=> 1
arr #=> [2, 3, 4, 5]
```

### Allocating Array
```ruby
# 1d array
arr = Array.new(10)
arr = [0] * 10

# array with default value
arr = Array.new(10) { |i| i }

# 2d array
arr = Array.new(10) { Array.new(20) }
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

## String
### Iterating over String
```ruby
s = "abcdefg"
s.each_char { |c| puts c }
```
### Appending and Prepending
```ruby
# Append
s = "abc"
s.concat "cde"
s << "cde"

# Prepend
s.prepend "haha"
```

### isDigit and is Alpha
[so](http://stackoverflow.com/questions/14551256/how-to-find-out-in-ruby-if-a-character-is-a-letter-or-a-digit)
```ruby
def numeric?(lookAhead)
  lookAhead =~ /[0-9]/
end

def letter?(lookAhead)
  lookAhead =~ /[A-Za-z]/
end

# or using POSIX bracket expressions

def letter?(lookAhead)
  lookAhead =~ /[[:alpha:]]/
end

def numeric?(lookAhead)
  lookAhead =~ /[[:digit:]]/
end
```