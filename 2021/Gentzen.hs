data PropCalc =
  P | Q | R
  | Not PropCalc
  | And PropCalc PropCalc
  | Or PropCalc PropCalc
  | Imp PropCalc PropCalc
  deriving (Show, Eq)

data Pos = GoLeft | GoRight

type Path = [Pos]

apply :: Path -> (PropCalc -> PropCalc) -> PropCalc -> PropCalc
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
ruleJoin :: PropCalc -> PropCalc -> PropCalc
ruleJoin x y = And x y

-- And elim l
ruleSepL :: PropCalc -> PropCalc
ruleSepL (And x y) = x
ruleSepL x = x

-- And elim r
ruleSepR :: PropCalc -> PropCalc
ruleSepR (And x y) = y
ruleSepR x = x

-- Not intro
ruleDoubleTildeIntro :: PropCalc -> PropCalc
ruleDoubleTildeIntro x = Not (Not x)

-- Not elim
ruleDoubleTildeElim :: PropCalc -> PropCalc
ruleDoubleTildeElim (Not (Not x)) = x
ruleDoubleTildeElim (And (Not (Not x)) y) = And x y
ruleDoubleTildeElim x = x

-- Imp intro
ruleCarryOver :: (PropCalc -> PropCalc) -> PropCalc -> PropCalc
ruleCarryOver f x = Imp x (f x)

-- Imp elim
ruleDetachment :: PropCalc -> PropCalc -> PropCalc
ruleDetachment x (Imp x' y) | x == x' = y
ruleDetachment _ _ = error "Not applicable"

-- Contrapositive
ruleContra :: PropCalc -> PropCalc
ruleContra (Imp (Not y) (Not x)) = Imp x y
ruleContra (Imp x y) = Imp (Not y) (Not x)
ruleContra x = x

-- DeMorgan's rule
ruleDeMorgan :: PropCalc -> PropCalc
ruleDeMorgan (And (Not x) (Not y)) = Not (Or x y)
ruleDeMorgan (Not (Or x y)) = And (Not x) (Not y)
ruleDeMorgan x = x

-- Switcheroo
ruleSwitcheroo :: PropCalc -> PropCalc
ruleSwitcheroo (Or x y) = Imp (Not x) y
ruleSwitcheroo (Imp (Not x) y) = Or x y
ruleSwitcheroo x = x

{-
[ {push into fantasy}
  P {premise}
  ~~P {outcome}
] {pop out of fantasy}
-}
eg1 = ruleCarryOver ruleDoubleTildeIntro P

{-
[
  (P/\Q)
  P
  Q
  (Q/\P)
]
((P/\Q)->(Q/\P))
-}
eg2 = ruleCarryOver (\pq -> let P = ruleSepL pq in let Q = ruleSepR pq in ruleJoin Q P) (ruleJoin P Q)

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
eg3 = ruleCarryOver (\x -> ruleCarryOver (\y -> ruleJoin x y) Q) P

{-
(P -> ~~P)
~~~P -> ~P
(~P -> ~P)
(P \/ ~P)
-}
eg4 = ruleSwitcheroo $ apply [GoLeft] ruleDoubleTildeElim $ ruleContra eg1
