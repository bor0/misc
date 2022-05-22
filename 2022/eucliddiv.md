# Euclidean division

Given two integers $a$ and $d$, with $d \neq 0$, there exist unique integers $q$ and $r$ such that $a = qd + r$ and $0 \leq r < d$.

# Proof

## Existence

Let $q'$ be the largest number such that $q'd \leq a$ and $a < (q'+1)d$.

- Case $q'd = a$: It follows that $r = 0$ and thus there exists $q$ and $r$ such that $a = qd + r$ and $0 \leq r < q$.
- Case $q'd < a$: This case gives that some number $r'$ such that $q'd + r' = a$. So, $q'd < q'd + r'$ and since $a < (q'+1)d$, $q'd + r' < q'd + q'$ which is $0 < r' < q'$. Thus, there exists $q$ and $r$ such that $a = qd + r$.

Combine both $0 \leq r < q$ and $0 < r < q$ gives the general case $0 \leq r < q$.

This proof suggests a simple algorithm in Python:

```python
def div(a, d):
  q = 1
  # find largest such q
  while not (q*d <= a and a < (q+1)*d): q += 1
  return q

# Mod is defined by qd + r = a
def mod(a, d): return a - d*div(a, d)
```

## Existence (alternative)

From [Wikipedia](https://en.wikipedia.org/wiki/Euclidean_division#Existence):

> Let $q_1 = 0$ and $r_1 = a$, then these are non-negative numbers such that $a = dq_1 + r_1$. If $r_1 < d$ then the division is complete, so suppose $r_1 \geq d$. Then defining $q_2 = q_1 + 1$ and $r_2 = r_1 – d$, one has $a = dq_2 + r_2$ with $0 \leq r_2 < r_1$. [...] That is, there exist a natural number $k \leq r_1$ such that $a = dq_k + r_k$ and $0 \leq r_k < |d|$.

This proof suggests the following calculation as represented in Python:

```python
def divmod(a, d):
  (q, r) = (0, a)
  while r >= d:
    (q, r) = (q + 1, r - d)

  return (q, r)
```

## Uniqueness

Suppose $a = qd + r$ and $a = q'd + r'$ with $0 \leq r < d$ and $0 \leq r' < d$.

That is, $qd + r = q'd + r'$ implies $d(q - q') = r' - r$. But, $dk = r' - r$ implies that $d|(r' - r)$.

From $r' < d$ it follows that $r' - r < d - r$, thus $0 \leq r' - r < d$. Since $d|(r' - r)$, this means that $0 \leq dk < d$, i.e. $0 \leq k < 1$. Thus, $k = 0$, and $r' - r = 0$ concludes $r' = r$.

Thus, subtracting $r$ from $qd + r = q'd + r$ follows $dq = dq'$ and since $d \neq 0$, conclude $q = q'$.