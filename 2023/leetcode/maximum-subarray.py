"""
[a_0, a_1]
|--|
|-------|
if a_0 + a_1 > a_1, then newmax = a_0 + a_1
else newmax = a_1, starts a new subarray

newmax will contain local maxima, so we need to use the largest one
"""
def maxSubArray(self, nums):
    dp    = [math.inf] * len(nums)
    dp[0] = nums[0]

    for i in range(1, len(nums)):
        # either includes current number in the max, or starts from a new subarray
        # dp[i] will contain the maximum at index i
        dp[i] = max(dp[i-1] + nums[i], nums[i])

    return max(dp)
