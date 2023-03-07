# Problem

A coin is tossed for double or nothing. The coin has a 75% chance of landing on heads every time. You own $1000. How much money should you invest daily to maximize your profit after 10 days?

# Solution

First, we start with a more straightforward and concrete problem. Instead of 10 days, we consider 4 days.

## Simpler problem 1

Assume the percentage of investment $p$ to be 0.1. Furthermore, WLOG, we assume the first day is a loss, thus, the investments are:
- First day: $100, totaling $900
- Second day: $90, totaling $990
- Third day: $99, totaling $1089
- Fourth day: $108.9, totaling $1197.9

## Simpler problem 2

Assuming $p = 0.2$ and WLOG, assume the first day is a loss, the investments are:
- First day: $200, totaling $800
- Second day: $160, totaling $960
- Third day: $192, totaling $1152
- Fourth day: $230.4, totaling $1382.4

## Generalized solution

We can notice a pattern here. Namely, the equation that is calculated is $s \cdot (1 - p) \cdot (1 + p)^3$. The solution is to find $p$ such that the formula provides the largest number. We can do that by calculating derivatives or other means.

However, that formula is specifically for 4 days. We can extend it to 10 days as follows (note that exponents determine a probability):

$$s \cdot (1 - p)^{2.5} \cdot (1 + p)^{7.5}$$

Optimizing this for $s = 1000$, we find that $p = \cfrac{1}{2}$ produces the maximum value $\frac{2187\sqrt3}{2} \approx 1893.99$. So we should bet on 50% of the current value state every time.

## Discussion

In this article, I used mathematical logic mostly, starting with a concrete problem and generalizing it. In the language of statistics, we could have simply used [Kelly's criterion](https://en.wikipedia.org/wiki/Kelly_criterion). And indeed, it agrees with our numbers; plugging in $p = 0.75$, $b = 1$ in the formula $f^* = p - \frac{1 - p}{b}$ we get $0.5$.