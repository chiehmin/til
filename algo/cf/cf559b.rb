# http://codeforces.com/problemset/problem/560/D
def min_rpst(x)
	if x.length.even?
		m = x.length / 2
		p = x[0...m]
		q = x[m..-1]
		p = min_rpst p
		q = min_rpst q
		x = p < q ? p + q : q + p
	end
	x
end

s1 = gets.strip
s2 = gets.strip
puts (min_rpst(s1) == min_rpst(s2)) ? "YES" : "NO"
