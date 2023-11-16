# Description

You are given a **0-indexed** array of integers `nums` of length `n`. You are initially positioned at `nums[0]`.

Each element `nums[i]` represents the maximum length of a forward jump from index `i`. In other words, if you are at `nums[i]`, you can jump to any `nums[i + j]` where:

- `0 <= j <= nums[i]` and
- `i + j < n`

Return the *minimum number of jumps to reach* `nums[n - 1]`. The test cases are generated such that you can reach `nums[n - 1]`.

**Example 1:**
```
Input: nums = [2,3,1,1,4]
Output: 2
Explanation: The minimum number of jumps to reach the last index is 2. Jump 1 step from index 0 to 1, then 3 steps to the last index.
```

**Example 2:**

```
Input: nums = [2,3,0,1,4]
Output: 2
```

Constraints:

- `1 <= nums.length <= 10^4`
- `0 <= nums[i] <= 1000`
- It's guaranteed that you can reach `nums[n - 1]`.

# Solution

## Brute-force

The first intuitive approach for me was to write a function that takes an index, and calculates the best solution based on that index. The function `findJumps` achieves that:

```python
def findJumps(index, ns, ns_len):
    if index+1 == ns_len:
        return 0

    max_jumps = ns[index]
    jump = math.inf
    for i in range(1, max_jumps+1):
        if index + i >= ns_len:
            break
        jump = min(jump, 1 + findJumps(index + i, ns, ns_len))

    return jump
```

The same function in its mathematical form:

$$\text{findJumps}(|ns|, ns) = 0
\\
\text{findJumps}(i, ns) = \min_{1\leq j\leq ns[i]+1} \text{findJumps}(j, ns)
$$

To find the final answer, all we need to do is iterate through all indices:

```python
def jump(ns):
    ns_len = len(ns)
    jump = math.inf
    for i in range(ns_len):
        jump = min(jump, findJumps(0, ns, ns_len))
    return jump
```

## DP (Bottom-Up)

### Approach 1

The recurrent relation above gives us the idea how we can build `dp`.

$$
\text{dp}[i] = \min_{1 \leq j \leq \min(\text{ns}[i], n - i)} (1 + \text{dp}[i + j])
$$

The same formula expressed in code:

```python
def findJumps(index, ns, ns_len):
    dp = [math.inf] * ns_len
    dp[ns_len - 1] = 0

    for i in range(ns_len - 2, -1, -1):
        for j in range(1, ns[i] + 1):
            if i + j >= ns_len: break
            dp[i] = min(dp[i], 1 + dp[i+j])

    return dp[index]
```

`jump` is the same as with the brute-force approach, that is:

$$
\text{jump} = \min_{0 \leq i \leq |ns|-1} (i + \text{dp}[i])
$$

### Approach 2 (combined functions)

In this approach, we combine both `findJump` and `jump` into a single formula:

$$
\text{jump} = \min_{0 \leq i \leq |ns|-1} \left(i + \min_{1 \leq j \leq \min(\text{ns}[i], |n| - i)} (1 + \text{jump}[i + j])\right)
$$

This allows us to implement the following compact code:

```python
def jump(ns):
    ns_len = len(ns)
    dp = [math.inf] * (ns_len - 1) + [0]

    for i in range(ns_len - 1, -1, -1):
        if dp[i] == 0: continue # already minimum
        for j in range(1, min(ns[i] + 1, ns_len - i)):
            dp[i] = min(dp[i], 1 + dp[i+j])

    return dp[0]
```