---
title: "Arithmetical Expressions"
author: "Boro Sitnikovski"
---

```
This is a literate Haskell file. You can build an HTML with pandoc by running `pandoc -s Main.lhs -o Main.html` or run it with stack with `stack repl Main.lhs`.
```

This project demonstrates the calculation of a closed-form expression of a simple arithmetical language on top of a very simple imperative language (only assignment!). Fractions are used for representing the numbers though any data type can work.

First, let's import the dependencies:

> import qualified Data.Map as M -- Maps are useful, we need them to represent context.
> import Frac    -- Fractions!
> import Arith   -- Arithmetic expressions
> import Command -- Imperative commands on top of arithmetic expressions

Next, assume you have the following code:

```
z = x+1
y = z-2
```

With the "imperative" representation in Haskell:

> cmds1 = [
>   Assign 'Z' (Plus (Var 'X') (Lit (Frac 1 1))),
>   Assign 'Y' $ Minus (Var 'Z') (Lit (Frac 2 1)),
>   Assign 'Z' (Lit (Frac 0 1))
>   ]

This has a closed expression of $y=(x+1)-2$.

> cmds1closedExpr = calcClosedExpr 'Y' $ calcClosedExprs cmds1

These two lines produce the same result:

> eg1Imperative = eval (M.fromList [('X', Frac 3 1)]) cmds1
> eg1Closed = cmds1closedExpr >>= Just . aeval (M.fromList [('X', Frac 3 1)])

That is, for $x=3$, we have $y=2$.

```
Main> eg1Imperative
Right (fromList [('X',Frac 3 1),('Y',Frac 2 1),('Z',Frac 0 1)])
Main> eg1Closed
Just (Right (Frac 2 1))
```

Right now, the only possible command (on top of arithmetic) is assignment. We can add loops, etc. though calculating the closed-form expression for a loop might be trickier.
