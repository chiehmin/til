a, b, c = gets.split.map(&:to_i)

(-100..100).each do |x|
	if a * x ** 2 + b * x + c == 0
		puts x
		exit
	end
end

puts "No solution"
