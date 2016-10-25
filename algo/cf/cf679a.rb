primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
squares = [4, 9, 25, 49]
cnt = 0
primes.each do |prime|
	puts prime
	STDOUT.flush
	cnt += (gets.chomp == "yes") ? 1 : 0
end
squares.each do |square|
	puts square
	STDOUT.flush
	cnt += (gets.chomp == "yes") ? 2 : 0
end

puts cnt >= 2 ? "composite" : "prime"
