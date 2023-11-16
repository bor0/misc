"""
    0   1   2   3
0   1   1   1   1
1   1   2
2   1
3   1
"""

# all the zero-indices are 1, since we can only move down and right
# example: second diagonal is 2, since we can reach from top and from left
# to calculate that, we sum the top and the left
# this suggests the following recursive definition
# complexity is T_n = 2T_{n-1} - since we make two recursive calls (binary tree), so exponential 2^(n+m)
def uniquePathsRec(m, n):
    print(m,n) # there are many overlapping problems
    if m == 1 or n == 1: return 1
    if m < 1 or n < 1: return 0

    return uniquePathsRec(m - 1, n) + uniquePathsRec(m, n - 1)

# now, we can convert the recursive definition to DP to solve the overlapping problems
# complexity is polynomial O(mn), much more favorable than exponential
def uniquePaths(m, n):
    dp = [ [ 0 for _ in range(n)] for _ in range(m) ]

    for i in range(0, m): dp[i][0] = 1
    for i in range(0, n): dp[0][i] = 1

    for i in range(1, m):
        for j in range(1, n):
            # print(i,j)
            dp[i][j] += dp[i-1][j] + dp[i][j-1] # can only reach here from two places (up/left)

    # print(dp)

    return dp[m - 1][n - 1]
