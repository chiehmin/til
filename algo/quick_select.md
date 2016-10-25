# Quick Select
```ruby
def find_kth_largest(nums, k)
    # Using randomization to guarantee O(N)
    randomizeArray(nums)
    
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
def randomizeArray(nums)
    (0...nums.length).each do |i|
        j = rand(0...nums.length)
        nums[i], nums[j] = nums[j], nums[i]
    end
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