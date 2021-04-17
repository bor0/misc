module Gentzen where

import Common

data VarEg = P | Q | R deriving (Show, Eq)

data PropCalc a =
  PropVar a
  | Not (PropCalc a)
  | And (PropCalc a) (PropCalc a)
  | Or (PropCalc a) (PropCalc a)
  | Imp (PropCalc a) (PropCalc a)
  deriving (Show, Eq)

applyPropRule :: Path -> (PropCalc a -> PropCalc a) -> PropCalc a -> PropCalc a
applyPropRule [] f x = f x
applyPropRule (GoLeft:xs) f (Not x) = Not (applyPropRule xs f x)
applyPropRule (GoLeft:xs) f (And x y) = And (applyPropRule xs f x) y
applyPropRule (GoLeft:xs) f (Or x y) = Or (applyPropRule xs f x) y
applyPropRule (GoLeft:xs) f (Imp x y) = Imp (applyPropRule xs f x) y
applyPropRule (GoRight:xs) f (Not x) = Not (applyPropRule xs f x)
applyPropRule (GoRight:xs) f (And x y) = And x (applyPropRule xs f y)
applyPropRule (GoRight:xs) f (Or x y) = Or x (applyPropRule xs f y)
applyPropRule (GoRight:xs) f (Imp x y) = Imp x (applyPropRule xs f y)
applyPropRule _ _ x = x

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

-- Imp intro accepts a rule and an assumption (simply a well-formed formula, not necessarily proven)
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
eg4 = ruleSwitcheroo $ applyPropRule [GoLeft] ruleDoubleTildeElim $ ruleContra eg1
