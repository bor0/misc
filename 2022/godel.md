# Introduction

The two crucial aspects of [Gödel's incompleteness theorems](https://en.wikipedia.org/wiki/G%C3%B6del%27s_incompleteness_theorems) are self-reference and arithmization:

- A variation of the [Liar's paradox](https://en.wikipedia.org/wiki/Liar_paradox) "This statement is false" represented in number theoretical system (e.g. [Peano's axioms](https://en.wikipedia.org/wiki/Peano_axioms)) - "This statement is unprovable".
- Arithmization - representing formulas as numbers, that is, a number theoretical system representing its formulas

To represent these two ideas, we need to use a number theoretical system that is powerful enough.

# Affected systems

The theorems only affect those systems that define both addition and multiplication, such as Peano's axioms (which are powerful).

[Presburger arithmetic](https://en.wikipedia.org/wiki/Presburger_arithmetic) is Peano axioms without multiplication, and [Skolem arithmetic](https://en.wikipedia.org/wiki/Skolem_arithmetic) is Peano axioms without addition. Both of these arithmetics are decidable - meaning that there is an algorithm that will always return a correct value (e.g., true or false) instead of looping infinitely or producing a wrong answer.

Peano's axioms are affected by the theorems and thus are undecidable.

To see why we need _both_ addition and multiplication, we need to understand parts of the theorems which build on top of these operators.

# Representing formulas as numbers

One way to represent formulas as numbers is to agree on a convention, e.g., in `x = y`, we set `x` to 1, `=` to 2, and `y` to 3.

Observe how the following methods of representing sequences depend either on multiplication, addition, or both.

## Gödel numbering

Now, we can encode this formula as the following number: $2^1 \cdot 3^2 \cdot 5^3 = 2250$. Due to the [Fundamental theorem of arithmetic](https://en.wikipedia.org/wiki/Fundamental_theorem_of_arithmetic), we can extract $1$, $2$, and $3$ from $2250$. Thus, there is a one-to-one correspondence between "formulas" and natural numbers.

This idea is known as [Godel's encoding](https://en.wikipedia.org/wiki/G%C3%B6del_numbering#G%C3%B6del's_encoding).

## Chinese Remainder Theorem

However, in his original proof, Gödel used the [Chinese Remainder Theorem](./crt.md) to represent these statements. CRT works because it guarantees the uniqueness of the remainder of the division of the derived number $N$. For CRT to work, we need to generate coprime numbers. Gödel achieved that using [Gödel's beta function](https://planetmath.org/godelsbetafunction). 

In the following code, coprimes are generated using the Gödel's $\Gamma$ sequence:

```
gammaSeq n =
  let l = fact n in
  map (\x -> x * l + 1) [1..]
```

Coprimity:

```
> nub $ concat [ [gcd x y] | x <- take 4 $ gammaSeq 4, y <- take 4 $ gammaSeq 4, x /= y ]
[1]
> take 4 $ gammaSeq 4
[25,49,73,97]
```

Having these coprimes, we can now construct our sequence $(1, 2, 3)$ using CRT as follows:

```
> crt [(1, 25), (2, 49), (3, 73)]
(3726,89425)
```

To extract members:

```
> 3726 `mod` 25
1
> 3726 `mod` 49
2
> 3726 `mod` 73
3
```

# Functions and recursion

Gödel's proof relies on functions. For example, to represent formulas as numbers, we need recursion. More specifically, primitive recursion. Whether we decide to go with Gödel's numbering or the Chinese Remainder Theorem, in any case, we need a [divisibility algorithm](./eucliddiv.md) ($a = qd + r$) which uses _both_ addition and multiplication; this is why the system needs at least both addition and multiplication for it to be affected by the theorems.

However, [recursive functions](https://refl.blog/2022/05/30/recursion-from-first-principles/) also rely on addition in their axiomatic definitions.
