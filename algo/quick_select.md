# Quick Select
```ruby
def select(nums, k)
    k = nums.length - k
    lo, hi = 0, nums.length - 1
    while lo < hi 
        j = partition(nums, lo, hi)
        if j < k
            lo = j + 1
        elsif j > k
            hi = j - 1
        else
            break
        end
    end
    nums[k]
end
def partition(nums, lo, hi)
    p = lo
    (lo...hi).each do |i|
        if nums[i] <= nums[hi]
            nums[p], nums[i] = nums[i], nums[p]
            p += 1
        end
    end
    nums[p], nums[hi] = nums[hi], nums[p]
    p
end
```