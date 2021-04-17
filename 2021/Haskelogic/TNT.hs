module TNT where

import Data.List ((\\))
import Common
import Gentzen

data Vars = A | B | C | D | E deriving (Show, Eq)

data Arith =
  Var Vars
  | Z
  | S Arith
  | Plus Arith Arith
  | Mult Arith Arith
  deriving (Show, Eq)

data FOL =
  Eq Arith Arith
  | ForAll Vars (PropCalc FOL)
  | Exists Vars (PropCalc FOL)
  deriving (Show, Eq)

-- Might be useful for some rules that may require drilling, like `ruleInterchangeL`
applyFOLRule :: Path -> (PropCalc FOL -> PropCalc FOL) -> PropCalc FOL -> PropCalc FOL
applyFOLRule [] f x = f x
applyFOLRule (_:xs) f (PropVar (ForAll x y)) = PropVar (ForAll x (applyFOLRule xs f y))
applyFOLRule (_:xs) f (PropVar (Exists x y)) = PropVar (Exists x (applyFOLRule xs f y))
applyFOLRule (_:xs) f (Not x)                = Not (applyFOLRule xs f x)
applyFOLRule (GoLeft:xs) f (And x y)         = And (applyFOLRule xs f x) y
applyFOLRule (GoLeft:xs) f (Imp x y)         = Imp (applyFOLRule xs f x) y
applyFOLRule (GoLeft:xs) f (Or x y)          = Or (applyFOLRule xs f x) y
applyFOLRule (GoRight:xs) f (And x y)        = And x (applyFOLRule xs f y)
applyFOLRule (GoRight:xs) f (Imp x y)        = Imp x (applyFOLRule xs f y)
applyFOLRule (GoRight:xs) f (Or x y)         = Or x (applyFOLRule xs f y)
applyFOLRule _ _ x = x

-- Similar to applyFOLRule, but useful for terms within formulas (used by existence rule)
applyArithRule :: Path -> (Arith -> Arith) -> Arith -> Arith
applyArithRule [] f x = f x
applyArithRule (GoLeft:xs) f (Mult x y) = Mult (applyArithRule xs f x) y
applyArithRule (GoLeft:xs) f (Plus x y) = Plus (applyArithRule xs f x) y
applyArithRule (GoLeft:xs) f (S x) = S (applyArithRule xs f x)
applyArithRule (GoRight:xs) f (Mult x y) = Mult x (applyArithRule xs f y)
applyArithRule (GoRight:xs) f (Plus x y) = Plus x (applyArithRule xs f y)
applyArithRule (GoRight:xs) f (S x) = S (applyArithRule xs f x)
applyArithRule _ _ x = x

-- Substitution on equational level for a specific variable with arithmetical expression
substPropCalc :: PropCalc FOL -> Vars -> Arith -> PropCalc FOL
substPropCalc (PropVar (Eq a b)) v e = PropVar (Eq (substArith a v e) (substArith b v e))
substPropCalc (PropVar (ForAll x y)) v e = PropVar (ForAll x (substPropCalc y v e))
substPropCalc (PropVar (Exists x y)) v e = PropVar (Exists x (substPropCalc y v e))

-- Substitution function for arithmetical formulas
substArith :: Arith -> Vars -> Arith -> Arith
substArith (Var q) v e | q == v = e
substArith (S q) v e = S (substArith q v e)
substArith (Plus a b) v e = Plus (substArith a v e) (substArith b v e)
substArith (Mult a b) v e = Mult (substArith a v e) (substArith b v e)
substArith x v e = x

-- 2 plus 3 equals 4
eg1 = PropVar (Eq (Plus (S (S Z)) (S (S (S Z)))) (S (S (S (S Z)))))

-- 2 plus 2 is not equal to 3
eg2 = Not (PropVar (Eq (Plus (S (S Z)) (S (S Z))) (S (S (S Z)))))

-- if 1 equals to 0, then 0 equals to 1
eg3 = Imp (PropVar (Eq (S Z) Z)) (PropVar (Eq Z (S Z)))

-- forall a, not (S a = 0)
axiom1 = PropVar (ForAll A (Not (PropVar (Eq (S (Var A)) Z))))

-- forall a, (a + 0) = a
axiom2 = PropVar (ForAll A (PropVar (Eq (Plus (Var A) Z) (Var A))))

-- forall a, forall b, a + Sb = S(a + b)
axiom3 = PropVar (ForAll A (PropVar (ForAll B (PropVar (Eq (Plus (Var A) (S (Var B))) (S (Plus (Var A) (Var B))))))))

-- forall a, (a * 0) = 0
axiom4 = PropVar (ForAll A (PropVar (Eq (Mult (Var A) Z) Z)))

-- forall a, forall b, a * Sb = (a * b + a)
axiom5 = PropVar (ForAll A (PropVar (ForAll B (PropVar (Eq (Mult (Var A) (S (Var B))) (Plus (Mult (Var A) (Var B)) (Var A)))))))

-- Rule of specification: if forall u:x is a theorem, then so is x.
ruleSpec :: PropCalc FOL -> Vars -> Arith -> PropCalc FOL
ruleSpec (PropVar (ForAll x (PropVar (Eq y z)))) v e | x == v = PropVar (Eq (substArith y v e) (substArith z v e))
ruleSpec (PropVar (ForAll x (PropVar (ForAll y z)))) v e = PropVar (ForAll y (ruleSpec (PropVar (ForAll x z)) v e))
ruleSpec x _ _ = x

-- 0 * 0 = 0
eg5 = ruleSpec axiom4 A Z

boundVars :: PropCalc FOL -> [Vars]
boundVars (PropVar (ForAll s e)) = s : boundVars e
boundVars (PropVar (Exists s e)) = s : boundVars e
boundVars _ = []

-- Rule of generalization: if x is a theorem in which u occurs free, then so is forall u:x.
ruleGeneralize :: PropCalc FOL -> Vars -> PropCalc FOL
ruleGeneralize formula v | v `notElem` boundVars formula = PropVar (ForAll v formula)
ruleGeneralize x _ = x

eg5' = ruleGeneralize eg5 A

-- Rule of interchange: forall x !y -> ! exists x, y
ruleInterchangeL :: PropCalc FOL -> PropCalc FOL
ruleInterchangeL (PropVar (ForAll x (Not y))) = Not (PropVar $ Exists x y)
ruleInterchangeL x = x

-- Rule of interchange: ! exists x, y -> forall x !y
ruleInterchangeR :: PropCalc FOL -> PropCalc FOL
ruleInterchangeR (Not (PropVar (Exists x y))) = PropVar (ForAll x (Not y))
ruleInterchangeR x = x

-- Rule of existence: Suppose a term X appears in a formula. X can be replaced by a variable.
-- E.g. forall a, ~ (S a = 0) <-> exists b, forall a, ~ (S a = b)
-- The first path is at the logic level, and the second path is at the equational level
ruleExistenceR :: PropCalc FOL -> Vars -> Path -> Path -> PropCalc FOL
ruleExistenceR formula var path1 path2 = PropVar (Exists var $ applyFOLRule path1 (\formula' -> ruleExistenceHelper GoRight formula' var path2) formula)

ruleExistenceL :: PropCalc FOL -> Vars -> Path -> Path -> PropCalc FOL
ruleExistenceL formula var path1 path2 = PropVar (Exists var $ applyFOLRule path1 (\formula' -> ruleExistenceHelper GoLeft formula' var path2) formula)

ruleExistenceHelper :: Pos -> PropCalc FOL -> Vars -> Path -> PropCalc FOL
ruleExistenceHelper pos (PropVar (Eq a b)) var path =
  if pos == GoRight
  then PropVar (Eq a (replace path b var))
  else PropVar (Eq (replace path a var) b)
  where
  -- replace path in x with var
  replace path x var = applyArithRule path (\_ -> Var var) (Var var)
ruleExistenceHelper pos (PropVar (ForAll x y)) var path = PropVar (ForAll x (ruleExistenceHelper pos y var path))
ruleExistenceHelper pos (PropVar (Exists x y)) var path = PropVar (Exists x (ruleExistenceHelper pos y var path))
ruleExistenceHelper _ x _ _ = x

eg6 = ruleExistenceR axiom1 B [GoLeft,GoLeft] []
eg6' = ruleExistenceL axiom1 B [GoLeft,GoLeft] []

-- Rule of symmetry: a = b == b == a
ruleSymmetry :: PropCalc FOL -> PropCalc FOL
ruleSymmetry (PropVar (Eq a b)) = PropVar (Eq b a)
ruleSymmetry x = x

-- Rule of transitivity: a = b & b = c -> a = c
ruleTransitivity :: PropCalc FOL -> PropCalc FOL -> PropCalc FOL
ruleTransitivity (PropVar (Eq a b)) (PropVar (Eq b' c)) | b == b' = PropVar (Eq a c)
ruleTransitivity (PropVar (ForAll x y)) z = ruleTransitivity y z
ruleTransitivity (PropVar (Exists x y)) z = ruleTransitivity y z
ruleTransitivity x (PropVar (ForAll y z)) = ruleTransitivity x z
ruleTransitivity x (PropVar (Exists y z)) = ruleTransitivity x z
ruleTransitivity x y = error "Not applicable"

-- Rule of adding an S: a = b -> S a = S b
ruleAddS :: PropCalc FOL -> PropCalc FOL
ruleAddS (PropVar (Eq a b)) = PropVar (Eq (S a) (S b))
ruleAddS x = x

-- Rule of dropping an S: S a = S b -> a = b
ruleDropS :: PropCalc FOL -> PropCalc FOL
ruleDropS (PropVar (Eq (S a) (S b))) = PropVar (Eq a b)
ruleDropS x = x

-- Rule of induction: P(0) /\ (P(n) -> P(n+1)) -> P(n)
ruleInduction :: PropCalc FOL -> PropCalc FOL -> PropCalc FOL
ruleInduction base ih@(PropVar (ForAll x (Imp y z))) =
  let base' = substPropCalc y x Z
      conc  = substPropCalc y x (S (Var x)) in
  if base' == base && conc == z
  then PropVar (ForAll x y)
  else error "Cannot prove"
ruleInduction _ _ = error "Not applicable"

-- Proof using induction:

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
PropVar (ForAll A (PropVar (Eq (Plus Z (Var A)) (Var A))))
> axiom2
PropVar (ForAll A (PropVar (Eq (Plus (Var A) Z) (Var A))))
> applyFOLRule [GoRight] ruleSymmetry axiom2
PropVar (ForAll A (PropVar (Eq (Var A) (Plus (Var A) Z))))
-}

step1 = ruleSpec axiom3 A (S Z)
step2 = ruleSpec step1 B Z
step1' = ruleSpec axiom2 A (S Z)
step2' = ruleAddS step1'
step3 = ruleTransitivity step2 step2'

step2_1 = applyFOLRule [] ruleInterchangeL axiom1
step2_2 = applyFOLRule [GoRight, GoRight] ruleSymmetry step2_1
step2_3 = applyFOLRule [GoRight, GoRight] ruleDoubleTildeIntro step2_2 -- apply from Gentzen

step3_1 = applyFOLRule [GoLeft] ruleAddS TNT.eg3
step3_2 = applyFOLRule [GoLeft] ruleSymmetry step3_1
step3_3 = applyFOLRule [GoLeft] ruleDropS step3_2
