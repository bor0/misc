# Description

You have `n` dice, and each die has `k` faces numbered from `1` to `k`.

Given three integers `n`, `k`, and `target`, return *the number of possible ways (out of the k^n total ways)* to roll the dice, so the sum of the face-up numbers equals `target`. Since the answer may be too large, return it **modulo** 10^9 + 7

**Example 1:**

```
Input: n = 1, k = 6, target = 3
Output: 1
Explanation: You throw one die with 6 faces.
There is only one way to get a sum of 3.
```

**Example 2:**

```
Input: n = 2, k = 6, target = 7
Output: 6
Explanation: You throw two dice, each with 6 faces.
There are 6 ways to get a sum of 7: 1+6, 2+5, 3+4, 4+3, 5+2, 6+1.
```

**Example 3:**

```
Input: n = 30, k = 30, target = 500
Output: 222616187
Explanation: The answer must be returned modulo 10^9 + 7.
```

# Solution

## Brute-force

Having spent a lot of time with FP languages, writing recursive functions became easier. To get a better understanding of the problem, we start with the easiest solution: recursive brute-force.

```python
def numRollsToTargetBrute(n: int, k: int, t: int) -> int:
  if n == 0: return 1 if t == 0 else 0

  total = 0
  for i in range(1, k + 1):
    total += self.numRollsToTarget(n - 1, k, t - i)

  return total % 1000000007
```

This gives us the idea of the recurrence relation $f(n, k, t) = \sum\limits_{i=1}^k f(n - 1, k, t - i)$, with $f(0, k, 0) = 1$. That is:

$$f(n, k, t) = f(n - 1, k, t - 1) + f(n - 1, k, t - 2) + \ldots + f(n - 1, k, t - k)$$

## Dynamic programming (bottom-up)

Now that we have the recurrence relation, we can construct the DP array `dp[n][k][t]`:

- With the base case `dp[0][0][0] = dp[0][1][0] = ... = 1`
- And with the inductive step `dp[n][k][t] = dp[n-1][k][t-1] + dp[n-1][k][t-2] + ... + dp[n-1][k][t-k]`
  - Put simpler, `dp[n][k][t] = sum(dp[n-1][k][t-j] for j in range(1, k + 1))`

The only thing we need to do is make sure we don't step out of bounds during the induction; the following snippet can help us see that sometimes negative indices are produced:

```python
print[ (N - 1, K, T - j) for j in range( 1, k + 1 ) ]
```

To take care of the bounds, we just filter out the negatives:

```python
tuples = list(filter(lambda x: x[2] >= 0, tuples))
```

Thus, we arrive at the final solution:

```python
def numRollsToTargetDP(n: int, k: int, t: int) -> int:
  # Initialize a 3D array to store the results
  dp = [[[0 for _ in range(t + 1)] for _ in range(k + 1)] for _ in range(n + 1)]

  # Base case: f(0, k, 0) = 1
  for K in range(k + 1):
      dp[0][K][0] = 1

  # Fill the DP table using the recurrence relation
  for N in range(1, n + 1):
    for K in range(1, k + 1):
      for T in range(1, t + 1):
        tuples = [ (N - 1, K, T - j) for j in range( 1, k + 1 ) ]
        tuples = list(filter(lambda x: x[2] >= 0, tuples))
        dp[N][K][T] = sum(dp[N][K][T] for (N, K, T) in tuples)

  return dp[n][k][t] % 1000000007
```

We can clean this up a bit. Note that the second index `k` is not used at all in the calculation. This makes sense because we have that $f(n,k,t) = \ldots f(n-1,k,t-i) \ldots$.

We can also remove the `filter` and take care of it in the list comprehension:

```python
tuples = [ (N - 1, T - j) for j in range( 1, k + 1 ) if T - j >= 0 ]
```

Or, put simpler,

```python
tuples = [ (N - 1, T - j) for j in range( 1, min(T, k) + 1) ]
```

So, the final code becomes:

```python
def numRollsToTargetDP(n: int, k: int, t: int) -> int:
  # Initialize a 2D array to store the results
  dp = [[0 for _ in range(t + 1)] for _ in range(n + 1)]

  # Base case
  dp[0][0] = 1

  # Fill the DP table using the recurrence relation
  for N in range(1, n + 1):
    for T in range(1, t + 1):
      dp[N][T] = sum(dp[N][T] for (N, T) in [ (N - 1, T - j) for j in range( 1, min(T, k) + 1) ])

  return dp[n][t] % 1000000007
```
