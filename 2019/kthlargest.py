def findLargest(nums):
    (largest, index) = (nums[0], 0)

    for i in range(0, len(nums)):
        if nums[i] > largest:
            (largest, index) = (nums[i], i)

    return (largest, index)

def findKthLargest(nums, k):
    while k != 0:
        (largest, index) = findLargest(nums)
        del nums[index]
        k = k - 1

    return largest


print(findKthLargest([3, 5, 2, 4, 6, 8], 3))
