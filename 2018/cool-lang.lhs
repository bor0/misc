Cool language per TAPL
======================
First, let's define what `Term` is, per the definition in the book:

> data Term =
>     T
>     | F
>     | O
>     | IfThenElse Term Term Term
>     | Succ Term
>     | Pred Term
>     | IsZero Term
>     deriving (Show, Eq)

Evaluation of a term is straightforward:

> eval :: Term -> Term

Now, by pattern matching, we can attempt to reduce terms to constant values:

> eval (IfThenElse a b c) = if (eval a) == T then eval b else eval c
> eval (Succ k)           = Succ $ eval k
> eval (Pred (O))         = O
> eval (Pred (Succ k))    = eval k
> eval (IsZero k)         = if (eval k) == O then T else F
> eval a                  = a

Playing around with it:

```haskell
Prelude> let isOneOrLess x = eval (IfThenElse (IsZero (Pred x)) T F) in map isOneOrLess [O, Succ O, Succ (Succ O)]
[T,T,F]
```

Looks good. Now let's implement `elements` that will tell us how many elements are in a specific set of set of sets of terms:

> elements :: Int -> [Term]

The base case is simple:

> elements 0 = []

The next case will produce all possible combinations, per the recursive definition in the book

> elements n = [T, F, O] ++ (map Succ $ elements (n - 1))
>                        ++ (map Pred $ elements (n - 1))
>                        ++ (map IsZero $ elements (n - 1))
>                        ++ [ IfThenElse a b c | a <- elements (n - 1), b <- elements (n - 1), c <- elements (n - 1) ]

Evaluating:

```haskell
Prelude> map (length . elements) [1..3]
[3,39,59439]
```

Looks good! :)
