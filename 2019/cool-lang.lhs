Building a simple type-checker
==============================
This tutorial serves as a very short and quick summary of the first few chapters of TAPL.

Untyped simple language
=======================

Syntax
------

Our syntax, per BNF is defined as follows:

```
<term>  ::= <bool> | <num> | If <bool> Then <expr> Else <expr> | <arith>
<bool>  ::= T | F | IsZero <num>
<num>   ::= O
<arith> ::= Succ <num> | Pred <num>
```

> data Term =
>     T
>     | F
>     | O
>     | IfThenElse Term Term Term
>     | Succ Term
>     | Pred Term
>     | IsZero Term
>     | TVar String Term
>     deriving (Show, Eq)

We will use `TVar` later.

Inference rules
---------------

The semantics we use here are based on so called small-step style, which state how a term is rewritten to a specific value, written t -> v. In contrast, big-step style states how a specific term evaluates to a final value, written t ⇓ v.

Evaluation of a term is just pattern matching the inference rules. Given a term, it should produce a term:

> eval :: Term -> Term

Now, by pattern matching every inference rule, we will reduce terms:

Rule `E-IfTrue`:
```
If T Then t2 Else t3 -> t2
```

> eval (IfThenElse T t2 t3) = t2

Alternatively, for big-step semantics we have:

Rule `E-If-True2`:
```
t1 ⇓ true          t2 ⇓ v
-------------------------
If t1 Then t2 Else t3 ⇓ v
```

Rule `E-IfFalse`:
```
If F Then t2 Else t3 -> t3
```

> eval (IfThenElse F t2 t3) = t3

Rule `E-If`:
```
        t1 -> t'
------------------------
If t1 Then t2 Else t3
-> If t' Then t2 Else t3
```

> eval (IfThenElse t1 t2 t3) = let t' = eval t1 in IfThenElse t' t2 t3

Rule `E-Succ`:
```
     t1 -> t'
------------------
Succ t1 -> Succ t'
```

> eval (Succ t1) = let t' = eval t1 in Succ t'

Rule `E-PredZero`:
```
Pred O -> O
```

> eval (Pred O) = O

Rule `E-PredSucc`:
```
Pred (Succ k) = k
```

> eval (Pred (Succ k)) = k

Rule `E-Pred`:
```
     t1 -> t'
------------------
Pred t1 -> Pred t'
```

> eval (Pred t1) = let t' = eval t1 in Pred t'

Rule `E-IszeroZero`:
```
IsZero O = T
```

> eval (IsZero O) = T

Rule `E-IszeroSucc`:
```
IsZero (Succ t) = F
```

> eval (IsZero (Succ t)) = F

Rule `E-IsZero`:
```
       t1 -> t'
----------------------
IsZero t1 -> IsZero t'
```

> eval (IsZero t1) = let t' = eval t1 in IsZero t'

And no other term is a valid term:

> eval _ = error "No rule applies"

Conclusion
----------

As an example, evaluating the following:

```haskell
Main> eval $ Pred $ Succ $ Pred O
Pred O
```

Corresponds to the following inference rules:

```
             ----------- E-PredZero
             pred O -> O
       ----------------------- E-Succ
       succ (pred O) -> succ O
------------------------------------- E-Pred
pred (succ (pred O)) -> pred (succ O)
```

However, if we do:

```haskell
Main> eval $ IfThenElse O O O
*** Exception: No rule applies
```

It's type-checking time!

Typed simple language
=====================

Type syntax 
-----------

We extend the previous syntax with types, so the new one per BNF is defined as follows:

```
<type> ::= Bool | Nat
```

> data Type =
>     TBool            -- bools
>     | TNat           -- natural number
>     deriving (Show, Eq)

Inference rules
---------------

Getting a type of a term expects a type, and either returns an error or the type derived:

> typeOf :: Term -> Either String Type

Next step is to specify the typing rules.

Rule `T-True`:
```
T : Bool
```

> typeOf T = Right TBool

Rule `T-False`:
```
F : Bool
```

> typeOf F = Right TBool

Rule `T-Zero`:
```
O : Nat
```

> typeOf O = Right TNat

Rule `T-If`:
```
t1 : Bool  t2 : T  t3 : T
-------------------------
If t1 Then t2 Else t3 : T
```

> typeOf (IfThenElse t1 t2 t3) =
>     case typeOf t1 of
>         Right TBool ->
>             let t2' = typeOf t2
>                 t3' = typeOf t3 in
>                 if t2' == t3'
>                 then t2'
>                 else Left "Types mismatch"
>         _ -> Left "Not supported type for IfThenElse"

Rule `T-Succ`:
```
   t : Nat
------------
Succ t : Nat
```

> typeOf (Succ k) =
>     case typeOf k of
>         Right TNat -> Right TNat
>         _ -> error "Not supported type for Succ"


Rule `T-Pred`:
```
   t : Nat
------------
Pred t : Nat
```

> typeOf (Pred k) =
>     case typeOf k of
>         Right TNat -> Right TNat
>         _ -> error "Not supported type for Pred"

Rule `T-IsZero`:
```
    t : Nat
---------------
IsZero t : Bool
```

> typeOf (IsZero k) =
>     case typeOf k of
>         Right TNat -> Right TBool
>         _ -> error "Not supported type for IsZero"

Conclusion
----------

Going back to the previous example, we can now "safely" run, depending on type-check results:

```haskell
Main> typeOf $ IfThenElse O O O
Left "Not supported type for IfThenElse"
Main> typeOf $ IfThenElse T O (Succ O)
Right TNat
Main> typeOf $ IfThenElse F O (Succ O)
Right TNat
Main> eval $ IfThenElse T O (Succ O)
O
Main> eval $ IfThenElse F O (Succ O)
Succ O
Main> 
```

Context
=======

Our neat language supports evaluation and type checking, but does not allow for defining variables. To do that, we will need kind of a context (or environment).

> type Context = [(String, Binding)]
> type Binding = Type

We also get to use `TVar` at this point, for defining a variable.

The rule for adding a binding:

```
 G  a : T
----------
G |- a : T
```

> addBinding :: Context -> String -> Binding -> Context
> addBinding ctx varname b = (varname, b) : ctx

The rule for retrieving a binding:

```
a : T in G
----------
G |- a : T
```

> getTypeFromContext :: Context -> String -> Maybe Type
> getTypeFromContext [] _ = Nothing
> getTypeFromContext ((varname', b) : ctx) varname = if varname' == varname then Just b else getTypeFromContext ctx varname

Evaluation inference rules
--------------------------

`eval'` is exactly the same with `eval`, with the only addition to support retrieval of types for variables in a context.

> eval' :: Term -> Term
> eval' (TVar _ value) = value
> eval' (IfThenElse T t2 t3) = t2
> eval' (IfThenElse F t2 t3) = t3
> eval' (IfThenElse t1 t2 t3) = let t' = eval t1 in IfThenElse t' t2 t3
> eval' (Succ t1) = let t' = eval t1 in Succ t'
> eval' (Pred O) = O
> eval' (Pred (Succ k)) = k
> eval' (Pred t1) = let t' = eval t1 in Pred t'
> eval' (IsZero O) = T
> eval' (IsZero (Succ t)) = F
> eval' (IsZero t1) = let t' = eval t1 in IsZero t'
> eval' _ = error "No rule applies"

`safeEval` is eval plus typechecking:

> safeEval :: Context -> Term -> Either String Term
> safeEval ctx t = case (typeOf' ctx t) of
>     Right _ -> Right $ eval' t
>     Left e  -> Left e

Type-checking inference rules
-----------------------------

`typeOf'` is exactly the same with `typeOf`, with the only addition to support retrieval of types for variables in a context.

> typeOf' :: Context -> Term -> Either String Type
> typeOf' ctx (TVar varname _) = case getTypeFromContext ctx varname of
>     Just ty -> Right ty
>     _       -> Left "No type found in context"
> typeOf' _ T = Right TBool
> typeOf' _ F = Right TBool
> typeOf' _ O = Right TNat
> typeOf' ctx (IfThenElse t1 t2 t3) =
>     case typeOf' ctx t1 of
>         Right TBool ->
>             let t2' = typeOf' ctx t2
>                 t3' = typeOf' ctx t3 in
>                 if t2' == t3'
>                 then t2'
>                 else Left "Types mismatch"
>         _ -> Left "Not supported type for IfThenElse"
> typeOf' ctx (Succ k) =
>     case typeOf' ctx k of
>         Right TNat -> Right TNat
>         _ -> error "Not supported type for Succ"
> typeOf' ctx (Pred k) =
>     case typeOf' ctx k of
>         Right TNat -> Right TNat
>         _ -> error "Not supported type for Pred"
> typeOf' ctx (IsZero k) =
>     case typeOf' ctx k of
>         Right TNat -> Right TBool
>         _ -> error "Not supported type for IsZero"

Examples:

```haskell
Main> let ctx = [("a", TNat), ("b", TBool)]
Main> let expr = IfThenElse T (TVar "a" (Succ O)) (TVar "b" F) in eval' ctx expr
TVar "a" (Succ O)
Main> let expr = IfThenElse T (TVar "a" (Succ O)) (TVar "b" F) in safeEval ctx expr
Left "Types mismatch"
Main> let expr = IfThenElse T (TVar "a" (Succ O)) (TVar "b" F) in typeOf' ctx expr
Left "Types mismatch"
Main> let ctx = [("a", TNat), ("b", TNat)]
Main> let expr = IfThenElse T (TVar "a" (Succ O)) (TVar "b" O) in typeOf' ctx expr
Right TNat
Main> let expr = IfThenElse T (TVar "a" (Succ O)) (TVar "b" O) in safeEval ctx expr
Var "a" (Succ O)
```
