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
  deriving (Eq)

instance Show Arith where
  show (Var a)    = show a
  show Z          = "0"
  show (S a)      = "S(" ++ show a ++ ")"
  show (Plus a b) = "(" ++ show a ++ ")+(" ++ show b ++ ")"
  show (Mult a b) = "(" ++ show a ++ ")*(" ++ show b ++ ")"

data FOL =
  Eq Arith Arith
  | ForAll Vars (PropCalc FOL)
  | Exists Vars (PropCalc FOL)
  deriving (Eq)

instance Show FOL where
  show (Eq a b) = "(" ++ show a ++ ")=(" ++ show b ++ ")"
  show (ForAll x y) = "∀" ++ show x ++ "." ++ show y
  show (Exists x y) = "∃" ++ show x ++ "." ++ show y

-- Might be useful for some rules that may require drilling, like `ruleInterchangeL`
applyFOLRule :: Path -> (Proof (PropCalc FOL) -> Proof (PropCalc FOL)) -> Proof (PropCalc FOL) -> Proof (PropCalc FOL)
applyFOLRule xs f (Proof x) = Proof $ go xs (\x -> fromProof $ f (Proof x)) x
  where
  go :: Path -> (PropCalc FOL -> PropCalc FOL) -> PropCalc FOL -> PropCalc FOL
  go [] f x = f x
  go (_:xs) f (PropVar (ForAll x y)) = PropVar (ForAll x (go xs f y))
  go (_:xs) f (PropVar (Exists x y)) = PropVar (Exists x (go xs f y))
  go (_:xs) f (Not x)                = Not (go xs f x)
  go (GoLeft:xs) f (And x y)         = And (go xs f x) y
  go (GoLeft:xs) f (Imp x y)         = Imp (go xs f x) y
  go (GoLeft:xs) f (Or x y)          = Or (go xs f x) y
  go (GoRight:xs) f (And x y)        = And x (go xs f y)
  go (GoRight:xs) f (Imp x y)        = Imp x (go xs f y)
  go (GoRight:xs) f (Or x y)         = Or x (go xs f y)
  go _ _ x = x

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
substPropCalc :: Proof (PropCalc FOL) -> Vars -> Arith -> Proof (PropCalc FOL)
substPropCalc (Proof f) v e = Proof $ go f v e
  where
  go :: PropCalc FOL -> Vars -> Arith -> PropCalc FOL
  go (PropVar (Eq a b)) v e = PropVar (Eq (substArith a v e) (substArith b v e))
  go (PropVar (ForAll x y)) v e = PropVar (ForAll x (go y v e))
  go (PropVar (Exists x y)) v e = PropVar (Exists x (go y v e))

-- Substitution function for arithmetical formulas
substArith :: Arith -> Vars -> Arith -> Arith
substArith (Var q) v e | q == v = e
substArith (S q) v e = S (substArith q v e)
substArith (Plus a b) v e = Plus (substArith a v e) (substArith b v e)
substArith (Mult a b) v e = Mult (substArith a v e) (substArith b v e)
substArith x v e = x

-- forall a, not (S a = 0)
axiom1 = Proof $ PropVar (ForAll A (Not (PropVar (Eq (S (Var A)) Z))))

-- forall a, (a + 0) = a
axiom2 = Proof $ PropVar (ForAll A (PropVar (Eq (Plus (Var A) Z) (Var A))))

-- forall a, forall b, a + Sb = S(a + b)
axiom3 = Proof $ PropVar (ForAll A (PropVar (ForAll B (PropVar (Eq (Plus (Var A) (S (Var B))) (S (Plus (Var A) (Var B))))))))

-- forall a, (a * 0) = 0
axiom4 = Proof $ PropVar (ForAll A (PropVar (Eq (Mult (Var A) Z) Z)))

-- forall a, forall b, a * Sb = (a * b + a)
axiom5 = Proof $ PropVar (ForAll A (PropVar (ForAll B (PropVar (Eq (Mult (Var A) (S (Var B))) (Plus (Mult (Var A) (Var B)) (Var A)))))))

-- Rule of specification: if forall u:x is a theorem, then so is x.
ruleSpec :: Proof (PropCalc FOL) -> Vars -> Arith -> Proof (PropCalc FOL)
ruleSpec (Proof f) v e = Proof $ go f v e
  where
  go :: PropCalc FOL -> Vars -> Arith -> PropCalc FOL
  go (PropVar (ForAll x (PropVar (Eq y z)))) v e | x == v = PropVar (Eq (substArith y v e) (substArith z v e))
  go (PropVar (ForAll x (PropVar (ForAll y z)))) v e = PropVar (ForAll y (go (PropVar (ForAll x z)) v e))
  go x _ _ = x

boundVars :: PropCalc FOL -> [Vars]
boundVars (PropVar (ForAll s e)) = s : boundVars e
boundVars (PropVar (Exists s e)) = s : boundVars e
boundVars _ = []

-- Rule of generalization: if x is a theorem in which u occurs free, then so is forall u:x.
ruleGeneralize :: Proof (PropCalc FOL) -> Vars -> Proof (PropCalc FOL)
ruleGeneralize (Proof formula) v | v `notElem` boundVars formula = Proof $ PropVar (ForAll v formula)
ruleGeneralize x _ = x

-- Rule of interchange: forall x !y -> ! exists x, y
ruleInterchangeL :: Proof (PropCalc FOL) -> Proof (PropCalc FOL)
ruleInterchangeL (Proof (PropVar (ForAll x (Not y)))) = Proof $ Not (PropVar $ Exists x y)
ruleInterchangeL x = x

-- Rule of interchange: ! exists x, y -> forall x !y
ruleInterchangeR :: Proof (PropCalc FOL) -> Proof (PropCalc FOL)
ruleInterchangeR (Proof (Not (PropVar (Exists x y)))) = Proof $ PropVar (ForAll x (Not y))
ruleInterchangeR x = x

-- Rule of existence: Suppose a term X appears in a formula. X can be replaced by a variable.
-- E.g. forall a, ~ (S a = 0) <-> exists b, forall a, ~ (S a = b)
-- The first path is at the logic level, and the second path is at the equational level
ruleExistenceR :: Proof (PropCalc FOL) -> Vars -> Path -> Path -> Proof (PropCalc FOL)
ruleExistenceR (Proof formula) var path1 path2 =
  Proof $ PropVar (Exists var $ fromProof $ applyFOLRule path1 (\formula' -> ruleExistenceHelper GoRight formula' var path2) $ Proof formula)

ruleExistenceL :: Proof (PropCalc FOL) -> Vars -> Path -> Path -> Proof (PropCalc FOL)
ruleExistenceL (Proof formula) var path1 path2 =
  Proof $ PropVar (Exists var $ fromProof $ applyFOLRule path1 (\formula' -> ruleExistenceHelper GoLeft formula' var path2) $ Proof formula)

ruleExistenceHelper :: Pos -> Proof (PropCalc FOL) -> Vars -> Path -> Proof (PropCalc FOL)
ruleExistenceHelper pos (Proof a) var path = Proof $ go pos a var path
  where
  go :: Pos -> PropCalc FOL -> Vars -> Path -> PropCalc FOL
  go pos (PropVar (Eq a b)) var path =
    if pos == GoRight
    then PropVar (Eq a (replace path b var))
    else PropVar (Eq (replace path a var) b)
    where
    -- replace path in x with var
    replace path x var = applyArithRule path (\_ -> Var var) (Var var)
  go pos (PropVar (ForAll x y)) var path = PropVar (ForAll x (go pos y var path))
  go pos (PropVar (Exists x y)) var path = PropVar (Exists x (go pos y var path))
  go _ x _ _ = x

-- Rule of symmetry: a = b == b == a
ruleSymmetry :: Proof (PropCalc FOL) -> Proof (PropCalc FOL)
ruleSymmetry (Proof (PropVar (Eq a b))) = Proof $ PropVar (Eq b a)
ruleSymmetry x = x

-- Rule of transitivity: a = b & b = c -> a = c
ruleTransitivity :: Proof (PropCalc FOL) -> Proof (PropCalc FOL) -> Proof (PropCalc FOL)
ruleTransitivity (Proof x) (Proof y) = Proof $ go x y
  where
  go :: PropCalc FOL -> PropCalc FOL -> PropCalc FOL
  go (PropVar (Eq a b)) (PropVar (Eq b' c)) | b == b' = PropVar (Eq a c)
  go (PropVar (ForAll x y)) z = go y z
  go (PropVar (Exists x y)) z = go y z
  go x (PropVar (ForAll y z)) = go x z
  go x (PropVar (Exists y z)) = go x z
  go x y = error "Not applicable"

-- Rule of adding an S: a = b -> S a = S b
ruleAddS :: Proof (PropCalc FOL) -> Proof (PropCalc FOL)
ruleAddS (Proof (PropVar (Eq a b))) = Proof $ PropVar (Eq (S a) (S b))
ruleAddS x = x

-- Rule of dropping an S: S a = S b -> a = b
ruleDropS :: Proof (PropCalc FOL) -> Proof (PropCalc FOL)
ruleDropS (Proof (PropVar (Eq (S a) (S b)))) = Proof $ PropVar (Eq a b)
ruleDropS x = x

-- Rule of induction: P(0) /\ (P(n) -> P(n+1)) -> P(n)
ruleInduction :: Proof (PropCalc FOL) -> Proof (PropCalc FOL) -> Proof (PropCalc FOL)
ruleInduction base (Proof ih@(PropVar (ForAll x (Imp y z)))) =
  -- in base' and conc, y is Proof y because it's an assumption
  let base' = substPropCalc (Proof y) x Z
      conc  = substPropCalc (Proof y) x (S (Var x)) in
  -- similarly, z is Proof z here
  if base' == base && conc == Proof z
  then Proof $ PropVar (ForAll x y)
  else error "Cannot prove"
ruleInduction _ _ = error "Not applicable"
