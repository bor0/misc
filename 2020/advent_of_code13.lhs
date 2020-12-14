---
title: "Advent of Code #13"
author: "Boro Sitnikovski"
---

```
This is a literate Haskell file. You can build an HTML with pandoc by running `pandoc -s advent_of_code13.lhs -o advent_of_code13.html` or run it with stack with `stack repl advent_of_code13.lhs`.
```

In this post, we'll tackle the 13th problem of AoC2020, [Shuttle Search](https://adventofcode.com/2020/day/13).

Part one
========

This part was straight-forward. We ignore the `x` in the list, so e.g. `[7,13,x,x,59,x,31,19]` becomes `[7,13,59,31,19]`. For this list and a given stamp of 939, to find the departure we need to find all earliest departures after 939, so the list becomes `[945,949,944,961,950]`. Earliest is 944 (bus ID 59), so we have 944 - 939 = 5 minutes before it departs, and so 5 * 59 = 295.

In code:

> findEarliestBus busIds stamp = ( fst nearestStampId - stamp ) * snd nearestStampId where
>   stampIds       = map (\x -> (x * (1 + stamp `div` x), x)) busIds
>   nearestStampId = minimum stampIds

And an example:

```
Main> map (\x -> (x * (1 + 939 `div` x), x)) [7,13,59,31,19]
[(945,7),(949,13),(944,59),(961,31),(950,19)]
Main> findEarliestBus [7,13,59,31,19] 939
295
```

Part two
========

First attempt
-------------

This part is a little bit trickier. The naive, straight-forward solution is brute force.

If in the previous part we ignored the `x`s, now they turn to `1`s.

We start by implementing a predicate such that it will test if all bus ids leave at a given timestamp:

> -- This is O(n)
> busesDepart busIds stamp = go busIds stamp 0 where
>   go []     _     _   = True
>   go (x:xs) stamp cnt = 0 == (cnt + stamp) `mod` x && go xs stamp (cnt + 1)

Giving it a few tries:

```
Main> busesDepart [17,1,13,19] 3417
True
Main> busesDepart [17,1,13,19] 3418
False
Main> busesDepart [67,7,59,61] 754018
True
```

I had already found 3417 and 754018, but the real problem that we need to solve is finding these numbers, not just checking if they are valid. Bruteforcing:

> findEarliestTimestamp busIds = go busIds 0 where
>   go busIds stamp = if busesDepart busIds stamp then stamp else go busIds (stamp + 1)

Trying it out on a few examples:

```
Main> findEarliestTimestamp [17,1,13,19] -- takes a few secs
3417
Main> findEarliestTimestamp [67,7,59,61] -- takes a few secs
754018
Main> findEarliestTimestamp [67,1,7,59,61] -- takes a little longer
779210
Main> findEarliestTimestamp [67,7,1,59,61] -- takes a little longer
1261476
Main> findEarliestTimestamp [1789,37,47,1889] -- too long
```

Each processing (`busesDepart`) takes `O(n)` and we are trying this out until we find an answer, which, depending on the answer can get quite long. Given that the input is even larger than the last example, we need to think of a different way to attack this.

Modular arithmetic
------------------

The bruteforce solution gave me an insight of the problem we are trying to solve, namely, for the list [17,1,13,19] we need to find `cnt` such that:

```
0 == cnt `mod` 17
0 == cnt + 1 `mod` 1
0 == cnt + 2 `mod` 13
0 == cnt + 3 `mod` 19
<->
cnt     = 0 (mod 17)
cnt + 1 = 0 (mod 1)
cnt + 2 = 0 (mod 13)
cnt + 3 = 0 (mod 19)
```

The first thing I immediately noticed is that the bus ids are all prime numbers. If they are all prime numbers, then they are all coprime numbers to each other (not having common divisors with each other). So every number will be coprime with every other number (filtering the 1s out). I searched for some neat properties on the Wikipedia page about [Coprime integers](https://en.wikipedia.org/wiki/Coprime_integers#Properties), and found out the following property:

```
Given a, b are coprime: Every pair of congruence relations for an unknown integer x, of the form x = k (mod a) and x = m (mod b), has a solution (Chinese Remainder Theorem); in fact the solutions are described by a single congruence relation modulo ab.
```

What do we do from here? We will slightly convert the formulas by using a property from Wikipedia's page on [Modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic#Properties), namely that if a = b (mod n) then a + k = b + k (mod n). We end up with:

```
cnt = 0  (mod 17)
cnt = 1  (mod 1)
cnt = 11 (mod 13)
cnt = 16 (mod 19)
```

Now, it's obvious how we can apply the Chinese Remainder Theorem. Namely, e.g. for the numbers 17 and 13 from the example, we have that there's a `cnt` such that `cnt = 0 (mod 17)` and `cnt = 11 (mod 13)`. How do we find this `cnt` by computation? We proceed with reading the [Computation section](https://en.wikipedia.org/wiki/Chinese_remainder_theorem#Computation) on Wikipedia's page about the theorem.

In other words, we have that the solution belongs to the arithmetic progression a1, a1 + n1, a1 + 2n1, ..., that is, 0, 17, 2\*17, ..., n\*17.

Now, in this specific case, the solution is in 0 + k\*17, for some k. The first such number is 6\*17, because (6\*17) `mod` 13 = 11. That is, we found `k = 6`, i.e. the answer 102. With the previous (brute force) algorithm this would take 102 steps. Note that the theorem has exponential complexity, but it seems that we're working well enough within its supporting range.

```
Main> crt [(0,17)]
(0,17)
Main> crt [(0,17),(11,13)]
(102,221)
```

Thus, we have solved a system of equations using only two congruences. The idea applies further for multiple equations:

```
Main> crt [(0,17),(1,1),(11,13),(16,19)]
(3417,4199)
```

Implementation
--------------

Now it makes sense how we can use the theorem to solve the problem. We start with the implementation of it, first:

> -- Copy paste `crt` from https://stackoverflow.com/questions/35529211/chinese-remainder-theorem-haskell
> crt :: (Integral a, Foldable t) => t (a, a) -> (a, a)
> crt = foldr go (0, 1)
>     where
>     go (r1, m1) (r2, m2) = (r `mod` m, m)
>         where
>         r = r2 + m2 * (r1 - r2) * (m2 `inv` m1)
>         m = m2 * m1
> 
>     -- Modular Inverse
>     a `inv` m = let (_, i, _) = gcd a m in i `mod` m
> 
>     -- Extended Euclidean Algorithm
>     gcd 0 b = (b, 0, 1)
>     gcd a b = (g, t - (b `div` a) * s, s)
>         where (g, s, t) = gcd (b `mod` a) a

Then, the solution is just to simply use the property that if a = b (mod n) then a + k = b + k (mod n) and convert the list before applying the theorem:

> findEarliestTimestamp' busIds = fst $ crt zipped where
>   zipped = map (\(x,y) -> ((x - y) `mod` x, x)) $ zip busIds [0..]

Trying it out:

```
Main> findEarliestTimestamp' [17,1,13,19] -- fast
3417
Main> findEarliestTimestamp' [67,7,59,61] -- fast
754018
Main> findEarliestTimestamp' [67,1,7,59,61] -- fast
779210
Main> findEarliestTimestamp' [67,7,1,59,61] -- fast
1261476
Main> findEarliestTimestamp' [1789,37,47,1889] -- fast
1202161486
```

Conclusion
==========

This was interesting to tackle, required some research of mathematical properties but then once we found what we need to use, applying them was easy.
