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

For simplicity, we merge all them together in a single `Term`.

> data Term =
>     T
>     | F
>     | O
>     | IfThenElse Term Term Term
>     | Succ Term
>     | Pred Term
>     | IsZero Term
>     | TVar String
>     | Pair Term Term
>     | EitherL Term
>     | EitherR Term
>     | Let String Term Term
>     deriving (Show, Eq)

We will use `TVar`, `Pair`, `EitherL`, `EitherR`, and `LetIn` later.

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

We now proceed with the remaining rules.

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
Pred (Succ k) -> k
```

> eval (Pred (Succ k)) = k

Rule `E-Pred` (why?):
```
     t1 -> t'
------------------
Pred t1 -> Pred t'
```

> eval (Pred t1) = let t' = eval t1 in Pred t'

Rule `E-IszeroZero`:
```
IsZero O -> T
```

> eval (IsZero O) = T

Rule `E-IszeroSucc`:
```
IsZero (Succ t) -> F
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

We create an additional previous syntax for types, so the new one per BNF is defined as follows:
```
<type> ::= Bool | Nat
```

> data Type =
>     TBool                -- bools
>     | TNat               -- natural number
>     | TyVar String       -- constants, use later
>     | TyPair Type Type   -- pairs, use later
>     | TyEither Type Type -- sum, use later
>     deriving (Show, Eq)

Inference rules
---------------

Getting a type of a term expects a term, and either returns an error or the type derived:

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
>         _ -> Left "Unsupported type for IfThenElse"

Rule `T-Succ`:
```
   t : Nat
------------
Succ t : Nat
```

> typeOf (Succ k) =
>     case typeOf k of
>         Right TNat -> Right TNat
>         _ -> Left "Unsupported type for Succ"

Rule `T-Pred`:
```
   t : Nat
------------
Pred t : Nat
```

> typeOf (Pred k) =
>     case typeOf k of
>         Right TNat -> Right TNat
>         _ -> Left "Unsupported type for Pred"

Rule `T-IsZero`:
```
    t : Nat
---------------
IsZero t : Bool
```

> typeOf (IsZero k) =
>     case typeOf k of
>         Right TNat -> Right TBool
>         _ -> Left "Unsupported type for IsZero"

Conclusion
----------

Going back to the previous example, we can now "safely" evaluate, depending on type-check results:

```haskell
Main> typeOf $ IfThenElse O O O
Left "Unsupported type for IfThenElse"
Main> typeOf $ IfThenElse T O (Succ O)
Right TNat
Main> typeOf $ IfThenElse F O (Succ O)
Right TNat
Main> eval $ IfThenElse T O (Succ O)
O
Main> eval $ IfThenElse F O (Succ O)
Succ O
```

Environment
===========

Our neat language supports evaluation and type checking, but does not allow for defining constants. To do that, we will need kind of an environment which will hold information about constants.

> type TyEnv = [(String, Type)] -- Type env
> type TeEnv = [(String, Term)] -- Term env

We also get to use `TVar` at this point, for defining a constant.

The rule for adding a binding:
```
 G  a : T
----------
G |- a : T
```

> addType :: String -> Type -> TyEnv -> TyEnv
> addType varname b env = (varname, b) : env

The rule for retrieving a binding:
```
a : T in G
----------
G |- a : T
```

> getTypeFromEnv :: TyEnv -> String -> Maybe Type
> getTypeFromEnv [] _ = Nothing
> getTypeFromEnv ((varname', b) : env) varname = if varname' == varname then Just b else getTypeFromEnv env varname

Analogously for terms:

> addTerm :: String -> Term -> TeEnv -> TeEnv
> addTerm varname b env = (varname, b) : env

> getTermFromEnv :: TeEnv -> String -> Maybe Term
> getTermFromEnv [] _ = Nothing
> getTermFromEnv ((varname', b) : env) varname = if varname' == varname then Just b else getTermFromEnv env varname

Evaluation inference rules
--------------------------

`eval'` is exactly the same as `eval`, with the only addition to support retrieval of values for constants.

> eval' :: TeEnv -> Term -> Term
> eval' env (TVar v) = case getTermFromEnv env v of
>     Just ty -> ty
>     _       -> error "No var found in env"

We will modify `IfThenElse` slightly to allow for evaluating variables:

> eval' env (IfThenElse T t2 t3) = eval' env t2
> eval' env (IfThenElse F t2 t3) = eval' env t3
> eval' env (IfThenElse t1 t2 t3) = let t' = eval' env t1 in IfThenElse t' t2 t3

> eval' env (Succ t1) = let t' = eval' env t1 in Succ t'
> eval' _ (Pred O) = O
> eval' _ (Pred (Succ k)) = k
> eval' env (Pred t1) = let t' = eval' env t1 in Pred t'
> eval' _ (IsZero O) = T
> eval' _ (IsZero (Succ t)) = F
> eval' env (IsZero t1) = let t' = eval' env t1 in IsZero t'

Also since we modified `IfThenElse`, we also need to consider base types:

> eval' _ T = T
> eval' _ F = F
> eval' _ O = O

Type-checking inference rules
-----------------------------

`typeOf'` is exactly the same as `typeOf`, with the only addition to support env and retrieval of types for constants in an env.

> typeOf' :: TyEnv -> Term -> Either String Type
> typeOf' env (TVar v) = case getTypeFromEnv env v of
>     Just ty -> Right ty
>     _       -> Left "No type found in env"
> typeOf' _ T = Right TBool
> typeOf' _ F = Right TBool
> typeOf' _ O = Right TNat
> typeOf' env (IfThenElse t1 t2 t3) =
>     case typeOf' env t1 of
>         Right TBool ->
>             let t2' = typeOf' env t2
>                 t3' = typeOf' env t3 in
>                 if t2' == t3'
>                 then t2'
>                 else Left $ "Type mismatch between " ++ show t2' ++ " and " ++ show t3'
>         _ -> Left "Unsupported type for IfThenElse"
> typeOf' env (Succ k) =
>     case typeOf' env k of
>         Right TNat -> Right TNat
>         _ -> Left "Unsupported type for Succ"
> typeOf' env (Pred k) =
>     case typeOf' env k of
>         Right TNat -> Right TNat
>         _ -> Left "Unsupported type for Pred"
> typeOf' env (IsZero k) =
>     case typeOf' env k of
>         Right TNat -> Right TBool
>         _ -> Left "Unsupported type for IsZero"

Examples:

```haskell
Main> let termEnv = addTerm "a" O $ addTerm "b" (Succ O) $ addTerm "c" F []
Main> let typeEnv = addType "a" TNat $ addType "b" TNat $ addType "c" TBool []
Main> let e = IfThenElse T (TVar "a") (TVar "b") in (eval' termEnv e, typeOf' typeEnv e)
(O,Right TNat)
Main> let e = IfThenElse T (TVar "a") (TVar "c") in (eval' termEnv e, typeOf' typeEnv e)
(O,Left "Type mismatch between Right TNat and Right TBool")
Main> let e = IfThenElse T F (TVar "c") in (eval' termEnv e, typeOf' typeEnv e)
(F,Right TBool)
```

Pairs
=====

Pairs are awesome, so we will implement them! The only change that we need to do is add this to the evaluator:

> eval' _ (Pair a b) = Pair a b

And also add this to the type checker:

> typeOf' env (Pair a b) =
>     let a' = typeOf' env a
>         b' = typeOf' env b in
>         case a' of
>             Right ta -> case b' of
>                 Right tb -> Right $ TyPair ta tb
>                 Left _ -> Left "Unsupported type for Pair"
>             Left _  -> Left "Unsupported type for Pair"

```haskell
Main> let e = IfThenElse T (Pair (TVar "a") (TVar "b")) O in (eval' termEnv e, typeOf' typeEnv e)
(Pair (TVar "a") (TVar "b"),Left "Type mismatch between Right (TyPair TNat TNat) and Right TNat")
Main> let e = IfThenElse T (Pair (TVar "a") (TVar "b")) (Pair O O) in (eval' termEnv e, typeOf' typeEnv e)
(Pair (TVar "a") (TVar "b"),Right (TyPair TNat TNat))
```

Sum
===

Union types are also awesome, and implementing them is easy, too! We add handling for left and right side on the evaluator

> eval' env (EitherL a) = eval' env a
> eval' env (EitherR a) = eval' env a

The type checker is also straight-forward, where TyVar "x" represents a polymorphic variable:

> typeOf' env (EitherL a) = case (typeOf' env a) of
>     Right t -> Right $ TyEither t (TyVar "x")
>     _       -> Left "Unsupported type for EitherL"
> typeOf' env (EitherR a) = case (typeOf' env a) of
>     Right t -> Right $ TyEither t (TyVar "x")
>     _       -> Left "Unsupported type for EitherR"

```haskell
Main> eval' termEnv (EitherL (TVar "a"))
O
Main> typeOf' typeEnv (EitherL (TVar "a"))
Right (TyEither TNat (TyVar "x"))
```

Let ... in ...
==============

Time to get the env rolling by adding support for `let ... in ...` syntax.

> eval' env (Let v t t') = eval' (addTerm v (eval' env t) env) t'

And the type checker:

> typeOf' env (Let v t t') = case typeOf' env t of
>    Right ty -> typeOf' (addType v ty env) t'
>    _        -> Left "Unsupported type for Let"

Some examples:

```haskell
Main> eval' termEnv (Let "y" (TVar "a") (Succ (TVar "y")))
Succ O
Main> typeOf' typeEnv (Let "y" (TVar "a") (Succ (TVar "y")))
Right TNat
```

Specify the inference rules for Pair, Sum, and Let ... in ....
