module Examples where

import TNT
import Common
import Gentzen

-- Gentzen
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
eg2 = ruleCarryOver (\pq -> ruleJoin (ruleSepR pq) (ruleSepL pq)) (And (PropVar P) (PropVar Q))

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

-- TNT

-- 2 plus 3 equals 4 (wff)
eg5 = PropVar (Eq (Plus (S (S Z)) (S (S (S Z)))) (S (S (S (S Z)))))

-- 2 plus 2 is not equal to 3 (wff)
eg6 = Not (PropVar (Eq (Plus (S (S Z)) (S (S Z))) (S (S (S Z)))))

-- if 1 equals to 0, then 0 equals to 1 (wff)
eg7 = Imp (PropVar (Eq (S Z) Z)) (PropVar (Eq Z (S Z)))

-- 0 * 0 = 0
eg8 = ruleSpec axiom4 A Z
-- forall a.0 * 0 = 0
eg8' = ruleGeneralize eg8 A

--axiom1 : forall a. not(Sa)=0
--eg9 = exists b.forall a. not(Sa)=B
eg9 = ruleExistenceR axiom1 B [GoLeft,GoLeft] []
--eg9' = exists b.forall a. not(b)=0
eg9' = ruleExistenceL axiom1 B [GoLeft,GoLeft] []

-- Example proof using induction:

-- Part 1:
-- PropVar (Eq (Plus Z Z) Z)
egIndBase = ruleSpec (ruleSpec axiom2 B Z) A Z

-- Part 2:
-- PropVar (ForAll A (Imp (PropVar (Eq (Plus Z (Var A)) (Var A))) (PropVar (Eq (Plus Z (S (Var A))) (S (Var A))))))
egIndHyp_1 = axiom3
egIndHyp_2 = ruleSpec egIndHyp_1 A Z
egIndHyp_3 = ruleSpec egIndHyp_2 B (Var A)
egIndHyp_4 = ruleCarryOver impRule (PropVar (Eq (Plus Z (Var A)) (Var A)))
  where
  impRule formula = substPropCalc (ruleAddS formula) A (Var A)
egIndHyp_5 = applyFOLRule [GoRight] rule egIndHyp_4
  where
  rule formula = ruleTransitivity egIndHyp_3 formula
egIndHyp  = ruleGeneralize egIndHyp_5 A

-- Proof
egInd     = ruleInduction egIndBase egIndHyp

{-
> egInd
⊢ ∀A.((0)+(A))=(A)
> axiom2
⊢ ∀A.((A)+(0))=(A)
> applyFOLRule [GoRight] ruleSymmetry axiom2
⊢ ∀A.(A)=((A)+(0))
-}

step1 = ruleSpec axiom3 A (S Z)
step2 = ruleSpec step1 B Z
step1' = ruleSpec axiom2 A (S Z)
step2' = ruleAddS step1'
step3 = ruleTransitivity step2 step2'

step2_1 = applyFOLRule [] ruleInterchangeL axiom1
step2_2 = applyFOLRule [GoRight, GoRight] ruleSymmetry step2_1
step2_3 = applyFOLRule [GoRight, GoRight] ruleDoubleTildeIntro step2_2 -- apply from Gentzen

step3_1 = ruleCarryOver ruleSymmetry (PropVar (Eq (S Z) Z))
step3_2 = applyFOLRule [GoLeft] ruleAddS step3_1
step3_3 = applyFOLRule [GoLeft] ruleSymmetry step3_1
step3_4 = applyFOLRule [GoLeft] ruleDropS step3_3
