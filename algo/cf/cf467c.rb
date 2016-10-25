n, m, k = gets.split.map(&:to_i)
arr = [0]
arr.concat gets.split.map(&:to_i)
(1..n).each { |i| arr[i] += arr[i - 1] }
dp = Array.new(n + 1) { Array.new(k + 1) { 0 } }
(m..n).each do |i|
	(1..k).each do |j|
		dp[i][j] = [ dp[i - 1][j],  dp[i - m][j - 1] + arr[i] - arr[i - m] ].max
	end
end
puts dp[n][k]
