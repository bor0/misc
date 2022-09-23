Consider:

```
1. Pick a number, like 4293, for example.
2. Now add up all its digits individually: 4 + 2 + 9 + 3 = 18.
3. Add up all its digits recursively until there is only one digit left: 18 -> 1 + 8 = 9
4. Now let's go back to the initial number (4293) but, instead of adding them individually, let's do it in pairs: 42 + 93 = 135
5. We continue adding their digits in pairs recursively: 13 + 5 = 18 (or 1 + 35 = 36)
6. We reduce the number until there is one digit left: 1 + 8 = 9 (or 3 + 6 = 9).
```

Note we always get the same result (compare the result from steps 3 and 6), no matter how we add its digits.

---

Whether you add $n = 1000a + 100b + 10c + 1d$ or $n' = 10a + b + 10c + d$ (two pairs) or $x = a + b + c + d$ it will be the same, because:

1. $n - x$ is multiple of 9
2. $n' - x$ is multiple of 9
3. $n' - n$ is multiple of 9

What do we know about numbers that are multiple of 9? They produce the same sum of digits. So if $n - x$ and $n' - x$ produce the same sum, then $n$ and $n'$ must produce the same sum as well (irrelevant if they are no longer multiple of 9)

Reference: https://math.stackexchange.com/questions/1221698/why-is-the-sum-of-the-digits-in-a-multiple-of-9-also-a-multiple-of-9