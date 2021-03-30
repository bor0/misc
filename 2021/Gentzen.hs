module Gentzen where

data VarEg = P | Q | R deriving (Show)

data PropCalc a =
  PropVar a
  | Not (PropCalc a)
  | And (PropCalc a) (PropCalc a)
  | Or (PropCalc a) (PropCalc a)
  | Imp (PropCalc a) (PropCalc a)
  deriving (Show, Eq)

data Pos = GoLeft | GoRight

type Path = [Pos]

apply :: Path -> (PropCalc a -> PropCalc a) -> PropCalc a -> PropCalc a
apply [] f x = f x
apply (GoLeft:xs) f (Not x) = Not (apply xs f x)
apply (GoLeft:xs) f (And x y) = And (apply xs f x) y
apply (GoLeft:xs) f (Or x y) = Or (apply xs f x) y
apply (GoLeft:xs) f (Imp x y) = Imp (apply xs f x) y
apply (GoRight:xs) f (Not x) = Not (apply xs f x)
apply (GoRight:xs) f (And x y) = And x (apply xs f y)
apply (GoRight:xs) f (Or x y) = Or x (apply xs f y)
apply (GoRight:xs) f (Imp x y) = Imp x (apply xs f y)
apply _ _ x = x

-- And intro
ruleJoin :: PropCalc a -> PropCalc a -> PropCalc a
ruleJoin x y = And x y

-- And elim l
ruleSepL :: PropCalc a -> PropCalc a
ruleSepL (And x y) = x
ruleSepL x = x

-- And elim r
ruleSepR :: PropCalc a -> PropCalc a
ruleSepR (And x y) = y
ruleSepR x = x

-- Not intro
ruleDoubleTildeIntro :: PropCalc a -> PropCalc a
ruleDoubleTildeIntro x = Not (Not x)

-- Not elim
ruleDoubleTildeElim :: PropCalc a -> PropCalc a
ruleDoubleTildeElim (Not (Not x)) = x
ruleDoubleTildeElim x = x

-- Imp intro
ruleCarryOver :: (PropCalc a -> PropCalc a) -> PropCalc a -> PropCalc a
ruleCarryOver f x = Imp x (f x)

-- Imp elim
ruleDetachment :: (Eq a) => PropCalc a -> PropCalc a -> PropCalc a
ruleDetachment x (Imp x' y) | x == x' = y
ruleDetachment _ _ = error "Not applicable"

-- Contrapositive
ruleContra :: PropCalc a -> PropCalc a
ruleContra (Imp (Not y) (Not x)) = Imp x y
ruleContra (Imp x y) = Imp (Not y) (Not x)
ruleContra x = x

-- DeMorgan's rule
ruleDeMorgan :: PropCalc a -> PropCalc a
ruleDeMorgan (And (Not x) (Not y)) = Not (Or x y)
ruleDeMorgan (Not (Or x y)) = And (Not x) (Not y)
ruleDeMorgan x = x

-- Switcheroo
ruleSwitcheroo :: PropCalc a -> PropCalc a
ruleSwitcheroo (Or x y) = Imp (Not x) y
ruleSwitcheroo (Imp (Not x) y) = Or x y
ruleSwitcheroo x = x

{-
[ {push into fantasy}
  P {premise}
  ~~P {outcome}
] {pop out of fantasy}
-}
eg1 = ruleCarryOver ruleDoubleTildeIntro (PropVar P)

{-
[
  (P/\Q)
  P
  Q
  (Q/\P)
]
((P/\Q)->(Q/\P))
-}
eg2 = ruleCarryOver (\pq -> ruleJoin (ruleSepR pq) (ruleSepL pq)) (ruleJoin (PropVar P) (PropVar Q))

{-
[
  P
  [
    Q
    P
    (P/\Q)
  ]
  (Q->(P/\Q))
]
(P->(Q->(P/\Q)))
-}
eg3 = ruleCarryOver (\x -> ruleCarryOver (\y -> ruleJoin x y) (PropVar Q)) (PropVar P)

{-
(P -> ~~P)
~~~P -> ~P
(~P -> ~P)
(P \/ ~P)
-}
eg4 = ruleSwitcheroo $ apply [GoLeft] ruleDoubleTildeElim $ ruleContra eg1
