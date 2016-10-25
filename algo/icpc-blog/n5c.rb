n = gets.to_i
ans = 0
until n == 0
	if n == 3
		ans += 3
		n = 0
	elsif (n & 3) == 3
		ans += 1
		n += 1
	elsif (n & 1) == 1
		ans += 1
		n -= 1
	else
		ans += 1
		n >>= 1
	end
end

puts ans
