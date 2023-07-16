# Random interesting factor lemmas

## Lemma 1: Any squared number has an odd number of factors.

Let's consider non-squared numbers first. Any non-squared number will have an even number of factors since they can be "paired". For example, consider the number 10 and its factors 1, 2, 5, and 10. The first factor is 1, and the "opposite" factor of that is $\frac{10}{1}$. In general, for any factor $k$ of 10, $\frac{10}{k}$ will be the "opposite" factor.

WLOG, the same reasoning applies to any number, not just 10. Now, if this any number $n$ is a square, then it means that $\sqrt n$ is also a factor. Thus, it has one more factor making up the total factors an odd number.

## Lemma 2: $k^2$ and $(k+1)^2$ have distinct factors (excluding 1)

For $n \neq 1$ to be a factor of both $k^2$ and $(k+1)^2$, it would mean that $\exists p, pn = k^2$ and also $\exists q, qn = (k+1)^2$. Thus, the possible pairs are $(p, n) = (k, k)$ or $(q, n) = (k+1, k+1)$, but $n$ cannot be both $k$ and $k+1$ so it cannot be a factor of both $k^2$ and $(k+1)^2$.