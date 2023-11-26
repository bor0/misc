"""
You are climbing a staircase. It takes n steps to reach the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

Example 1:

Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps

Example 2:

Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
"""

class Solution:
    def climbStairs(self, n: int) -> int:
        # return countStairs(n)
        # return countStairsIter(n)
        return fibonacci_dp(n+1)

"""
The definition "either climb X or Y" suggests branching! :)

Example:
                 6
         /               \
        4                 5
       / \               / \
      2   3             3   4 (subtree is 5)
     /   / \           / \
    0   1   2         1   2
         \ / \         \ / \
         0 0  1        0 0  1
               \             \
                0             0
     subtree above    subtree above is 3 + 5 = 8
       is 5

count zeroes as valid values
"""
# Recursive definition T_n = T_{n-1} + T_{n-2}
def countStairs(n):
    if n == 0: return 1
    if n < 0: return 0
    return countStairs(n - 1) + countStairs(n - 2)

def countStairsIter(n, m = 0):
    # exclude if we overstepped
    if m > n: return 0
    # good step
    if m == n: return 1

    return countStairsIter(n, m + 1) + countStairsIter(n, m + 2)

# Essentially, the previous definition is Fibonacci
def fibonacci_dp(n):
    if n <= 1:
        return n
    
    # Initialize a DP array to store Fibonacci numbers
    dp = [0] * (n + 1)
    dp[1] = 1

    # Calculate Fibonacci numbers iteratively
    for i in range(2, n + 1):
        dp[i] = dp[i - 1] + dp[i - 2]

    return dp[n]
