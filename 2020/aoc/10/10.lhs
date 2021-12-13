---
title: "Advent of Code #10"
author: "Boro Sitnikovski"
---

```
This is a literate Haskell file. You can build an HTML with pandoc by running `pandoc -s advent_of_code10.lhs -o advent_of_code10.html` or run it with stack with `stack repl advent_of_code10.lhs`.
```

In this post, we'll tackle the 10th problem of AoC2020, [Adapter Array](https://adventofcode.com/2020/day/10).

As usual, we start with the dependencies.

> import Data.Function (fix)
> import Data.List (nub)

Part one
========

For this part, we need to create a function such that given a list of integers (joltages), it will start with one of the elements `[1, 2, 3]` and keep iterating until either of `[n+1, n+2, n+3]` is in the list of joltages, while keeping track of which pick was made in a 3-tuple. The function `go` will serve as a helper function and it is tail recursive, maintaining the state of differences in each case of the 3-tuple.

> countAdapterDifferences :: [Int] -> (Int, Int, Int)
> countAdapterDifferences joltages
>   | 1 `elem` joltages = go 1 joltages' (1, 0, 0)
>   | 2 `elem` joltages = go 2 joltages' (0, 1, 0)
>   | 3 `elem` joltages = go 3 joltages' (0, 0, 1)
>   | otherwise = (0, 0, 0)
>   where
>   joltages' = 0 : (3 + maximum joltages) : joltages
>   go n l acc@(d1, d2, d3)
>       | (n + 1) `elem` l = go (n + 1) l (d1 + 1, d2, d3)
>       | (n + 2) `elem` l = go (n + 2) l (d1, d2 + 1, d3)
>       | (n + 3) `elem` l = go (n + 3) l (d1, d2, d3 + 1)
>   go _ _ acc = acc

Trying it out with the examples from AoC:

```
Main> countAdapterDifferences [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
(7,0,5)
Main> countAdapterDifferences [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]
(22,0,10)
```

The answer is just multiplying the first with the third element.

Part two
========

This part is slightly trickier. Given a list of joltages, we need to count all possible arrangements from 0 to `(3 + max list)` where in each step we increase by one of 1, 2, or 3. The obvious first approach is to bruteforce (generate) all the paths, and then calculate the length of this list:

> countAdapterCombinations :: [Int] -> Int
> countAdapterCombinations joltages = length $ nub lists where
>   lists = (if 1 `elem` joltages then go 1 [1] joltages else []) ++
>           (if 2 `elem` joltages then go 2 [2] joltages else []) ++
>           (if 3 `elem` joltages then go 3 [3] joltages else [])
>   go n path joltages =
>        (if n + 1 `elem` joltages then go (n + 1) ((n + 1) : path) joltages else ([path | validPath path]))
>     ++ (if n + 2 `elem` joltages then go (n + 2) ((n + 2) : path) joltages else ([path | validPath path]))
>     ++ (if n + 3 `elem` joltages then go (n + 3) ((n + 3) : path) joltages else ([path | validPath path]))
>     where validPath p = maximum joltages `elem` p

This works pretty well for small lists:

```
Main> countAdapterCombinations [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
8
Main> countAdapterCombinations [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]
19208
```

The first call was executed quite fast, while the second needed some time. However, if you try it on the input list, it will take a very long time, so we need to think of a different solution.

Let's try to come up with a recurrent formula. Let's assume our formula is `g(n)` where `n` is the number of the destination (target) that needs to be reached. There are a few cases to consider:

- If `n` is either 0 or 1, then `g(n) = 1` because to reach either of 0 or 1 from 0 takes 1 step.
- Otherwise, `n` can be reached from one of `n - 1`, `n - 2`, or `n - 3`. In this case, reached really means that `n - 1` or `n - 2` or `n - 3` is in the list of joltages. In general, we have that `g(n) = g(n - 1) + g(n - 2) + g(n - 3)`. More specifically, we have the following cases:
	- `n - 1` in joltages, `n - 2` in joltages, `n - 3` in joltages: `g(n) = g(n - 1) + g(n - 2) + g(n - 3)`
	- `n - 1` in joltages, `n - 2` in joltages: `g(n) = g(n - 1) + g(n - 2)`
	- `n - 1` in joltages, `n - 3` in joltages: `g(n) = g(n - 1) + g(n - 3)`
	- `n - 1` in joltages: `g(n) = g(n - 1)`
	- `n - 2` in joltages, `n - 3` in joltages: `g(n) = g(n - 2) + g(n - 3)`
	- `n - 2` in joltages: `g(n) = g(n - 2)`
	- `n - 3` in joltages: `g(n) = g(n - 3)`
	- Otherwise: `g(n) = 0`.

Let's try this with simple recursion:

> countAdapterCombinations' :: [Integer] -> Integer
> countAdapterCombinations' joltages = go joltages' (maximum joltages') where
>   joltages' = 0 : (3 + maximum joltages) : joltages
>   go joltages n
>     | n == 1 || n == 0 = 1
>     | n `elem` joltages = (if n - 1 `elem` joltages then go joltages (n - 1) else 0)
>                         + (if n - 2 `elem` joltages then go joltages (n - 2) else 0)
>                         + (if n - 3 `elem` joltages then go joltages (n - 3) else 0)
>     | otherwise = 0

Testing this implementation:

```
Main> countAdapterCombinations' [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
8
Main> countAdapterCombinations' [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]
19208
```

That was quite fast on the two examples but still slow on the actual input data. We need to do something different.

Part two (intro)
================

It was obvious to me that we need to use memoization (cache the values to avoid duplicate calculation), but I didn't know how to do this in Haskell so initially, I solved this problem in Python. For completeness, here's the Python code:

```python
def prepare_input(input_list):
  l = input_list[:]
  l.append(max(l)+3)
  l.append(0)
  return l

memo = {}

def count_joltage_combinations(n, joltages):
  if n in memo:
    return memo[n]

  if n == 1 or n == 0:
    return 1

  s = 0

  if n in joltages:
    s += count_joltage_combinations(n - 1, joltages) if (n - 1) in joltages else 0
    s += count_joltage_combinations(n - 2, joltages) if (n - 2) in joltages else 0
    s += count_joltage_combinations(n - 3, joltages) if (n - 3) in joltages else 0
  else:
    return 0

  memo[n] = s
  return s

newl = prepare_input(joltages)
print(count_joltage_combinations(max(newl), newl))
```

That worked pretty well, so we can use the same approach in Haskell but first, we need to learn about memoization in Haskell. A quick Google showed the [Memoization](https://wiki.haskell.org/Memoization) article on the Haskell Wiki.

First, we will start by writing a more generalized `go` - in that instead of calling itself, we can pass a function that it will call with the next parameter:

> go :: [Int] -> (Int -> Int) -> Int -> Int
> go joltages f n
>   | n == 1 || n == 0 = 1
>   | n `elem` joltages = (if n - 1 `elem` joltages then f (n - 1) else 0)
>                       + (if n - 2 `elem` joltages then f (n - 2) else 0)
>                       + (if n - 3 `elem` joltages then f (n - 3) else 0)
>   | otherwise = 0

To call this function with itself using `n = 1`, we have to do something like `go joltages (go joltages (go joltages ...) 1) 1`. That can be done easily as follows:

```
Main> let joltages = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ] in let f = (\x -> go joltages f x) in go joltages f 19
8
```

Cool, we get the same answer but using a more generalized `go`. There is a common abstraction for `let f (\x -> go joltages f x)` - a neater way to make the same call is using `fix`, where `fix f = f (fix f)`:

```
Main> :t fix
fix :: (a -> a) -> a
Main> let joltages = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ] in fix (go joltages) 19
8
```

At this point, we have a more generalized `go` but it's still as slow as the previous implementation. This is the part where the magic happens.

Haskell evaluation model
========================

Before we start implementing the memoized version of `go`, we will spend some time explaining how memoization works in Haskell by inspecting the evaluation model.

Sharing
-------

Consider the following piece of code:

```haskell
f x + f y + f x
```

In this example, there will be one evaluation for `f x`, one for `f y`, and another evaluation for `f x`. So, `f x` was evaluated twice. However, there's a trick we can use. Consider the next code:

```haskell
let x = map (+1) [0..] in (x !! 0, x !! 0)
```

Executing it means we are mapping the function `(+1)` on the infinite list, and this happens lazily - it will only get evaluated when we need it. Now, when we actually retrieve the first element `x !! 0`, it is like computing `0 + 1`. Note that we are doing that twice in the tuple. However, Haskell will only evaluate `0 + 1` once, even though it sees "two" `0 + 1`.

The reason for this is that in general, when Haskell sees `let f = ... f ...`, i.e. `f` referencing itself in the body, it will **share** the value of `f` instead of recalculating it. The rationale is: If you name it, you can share it. This allows Haskell to skip the recomputation of values - avoid duplicate computation.

Inlining
--------

You can test this; If you create a file named `test.hs` with the following contents, you will be able to see how the evaluation happens:

```haskell
import Debug.Trace

test = let x = trace "forced" (map (+1) [0..]) in (x !! 0, x !! 0)
```

It will produce:

```
Main> test
(forced
1,1)
```

However, if you run this expression directly in the REPL you will get different results:

```
Main> let x = trace "forced" (map (+1) [0..]) in (x !! 0, x !! 0)
(forced
1,forced
1)
```

The reason for that is that GHC optimized the expression by *inlining* it - it replaced `(x !! 0, x !! 0)` with ``("forced" `trace` 1, "forced" `trace` 1)``. The primary optimization mechanism in GHC is inlining, inlining and inlining.

However, note that this problem occurs just for this specific example, and memoization is not affected by it. The reason for that is GHC will not inline recursive things.

Monomorphism and Polymorphism
-----------------------------

For some reason, GHC thought that it should inline this expression. We can disable that behavior as shown in the following example:

```
Main> :set -XMonomorphismRestriction
Main> let x = trace "forced" (map (+1) [0..]) in (x !! 0, x !! 0)
(forced
1,1)
Main>
```

You might be wondering, why on earth did this happen? We start to dig a little into the internals of Haskell but I will keep it short.

A function with a polymorphic type is `t a`. A function with a monomorphic type is `[Int]` (or `List Int`) - so monomorphic is the opposite of polymorphic, it's like a particular instance of a polymorphic.

If we consider the expression `x = 4` with a type of `Num a => a` then it requires re-computation every time it will be used. The reason for that is Haskell can't be certain of what `x` really is, because `x :: Int` is different from `x :: Double`. I don't know about GHC internals much, but maybe it could use a map of `(Type, Value)` to keep the values of these types? Shrug.

This will not happen with monomorphic types since the types are static and can be memoized, so that's why `-XMonomorphismRestriction` fixes the problem.

Part two (final)
================

From the Haskell docs, the following `memoize` function is shown:

> memoize :: (Int -> a) -> (Int -> a)
> memoize f = (map f [0 ..] !!) -- not using eta-reduction may affect performance

Note how this function allows the *sharing* of values, so it will avoid recomputation. Now, finally, we have:

> countAdapterCombinations'' :: [Int] -> Int
> countAdapterCombinations'' joltages = fix (memoize . go joltages') (maximum joltages') where
>   joltages' = 0 : (3 + maximum joltages) : joltages

Running it a few times:

```
Main> countAdapterCombinations'' [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]
8
Main> countAdapterCombinations'' [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]
19208
```

Works pretty fast on the two example inputs, and also blazingly fast on the actual (large) input.

Putting it all together
=======================

We learned a lot about the Haskell evaluation model and how it allows us to cache computation. I would like to thank dminuoso and monochrom from #haskell@freenode for explaining the evaluation model to me.
