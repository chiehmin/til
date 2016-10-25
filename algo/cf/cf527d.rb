n = gets.to_i
arr = []
n.times do 
	x, w = gets.split.map(&:to_i)
	arr << [x - w, x + w]
end

arr.sort! do |a, b|
	a[1] <=> b[1]
end

ans = 0
now = -10**9
arr.each do |ele|
	if ele[0] >= now
		ans += 1
		now = ele[1]
	end
end

puts ans
