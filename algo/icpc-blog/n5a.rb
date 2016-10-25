segs = gets.split.map(&:to_i)
a = segs[0, 3].sort
b = segs[3, 3].sort

yes = true
(0..2).each do |i|
	yes &= a[i] <= b[i]
end

puts yes ? "Yes" : "No"
