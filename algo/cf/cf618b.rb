# http://codeforces.com/problemset/problem/618/B

n = gets.to_i
ans = []
n.times do |i|
    arr = gets.split.map(&:to_i)
    ans << arr.max
end
ans[ans.index(n - 1)] = n
puts ans * " "