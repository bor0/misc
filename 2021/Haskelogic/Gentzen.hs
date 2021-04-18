module Gentzen where

import Common

data VarEg = P | Q | R deriving (Show, Eq)

data PropCalc a =
  PropVar a
  | Not (PropCalc a)
  | And (PropCalc a) (PropCalc a)
  | Or (PropCalc a) (PropCalc a)
  | Imp (PropCalc a) (PropCalc a)
  deriving (Eq)

instance (Show a) => Show (PropCalc a) where
  show (PropVar a) = show a
  show (Not a)     = "¬" ++ show a
  show (And a b)   = "(" ++ show a ++ ")∧(" ++ show b ++ ")"
  show (Or a b)    = "(" ++ show a ++ ")∨(" ++ show b ++ ")"
  show (Imp a b)   = "(" ++ show a ++ ")→(" ++ show b ++ ")"

applyPropRule :: Path -> (Proof (PropCalc a) -> Proof (PropCalc a)) -> Proof (PropCalc a) -> Proof (PropCalc a)
applyPropRule xs f (Proof x) = Proof $ go xs (\x -> fromProof $ f (Proof x)) x
  where
  go :: Path -> (PropCalc a -> PropCalc a) -> PropCalc a -> PropCalc a
  go [] f x = f x
  go (GoLeft:xs) f (Not x) = Not (go xs f x)
  go (GoLeft:xs) f (And x y) = And (go xs f x) y
  go (GoLeft:xs) f (Or x y) = Or (go xs f x) y
  go (GoLeft:xs) f (Imp x y) = Imp (go xs f x) y
  go (GoRight:xs) f (Not x) = Not (go xs f x)
  go (GoRight:xs) f (And x y) = And x (go xs f y)
  go (GoRight:xs) f (Or x y) = Or x (go xs f y)
  go (GoRight:xs) f (Imp x y) = Imp x (go xs f y)
  go _ _ x = x

-- And intro
ruleJoin :: Proof (PropCalc a) -> Proof (PropCalc a) -> Proof (PropCalc a)
ruleJoin (Proof x) (Proof y) = Proof $ And x y

-- And elim l
ruleSepL :: Proof (PropCalc a) -> Proof (PropCalc a)
ruleSepL (Proof (And x y)) = Proof x
ruleSepL x = x

-- And elim r
ruleSepR :: Proof (PropCalc a) -> Proof (PropCalc a)
ruleSepR (Proof (And x y)) = Proof y
ruleSepR x = x

-- Not intro
ruleDoubleTildeIntro :: Proof (PropCalc a) -> Proof (PropCalc a)
ruleDoubleTildeIntro (Proof x) = Proof $ Not (Not x)

-- Not elim
ruleDoubleTildeElim :: Proof (PropCalc a) -> Proof (PropCalc a)
ruleDoubleTildeElim (Proof (Not (Not x))) = Proof x
ruleDoubleTildeElim x = x

-- Imp intro accepts a rule and an assumption (simply a well-formed formula, not necessarily proven)
-- Our data types are constructed such that all formulas are well-formed
ruleCarryOver :: (Proof (PropCalc a) -> Proof (PropCalc a)) -> PropCalc a -> Proof (PropCalc a)
ruleCarryOver f x = Proof $ Imp x $ fromProof (f (Proof x))

-- Imp elim
ruleDetachment :: (Eq a) => Proof (PropCalc a) -> Proof (PropCalc a) -> Proof (PropCalc a)
ruleDetachment (Proof x) (Proof (Imp x' y)) | x == x' = Proof y
ruleDetachment _ _ = error "Not applicable"

-- Contrapositive
ruleContra :: Proof (PropCalc a) -> Proof (PropCalc a)
ruleContra (Proof (Imp (Not y) (Not x))) = Proof $ Imp x y
ruleContra (Proof (Imp x y)) = Proof $ Imp (Not y) (Not x)
ruleContra x = x

-- DeMorgan's rule
ruleDeMorgan :: Proof (PropCalc a) -> Proof (PropCalc a)
ruleDeMorgan (Proof (And (Not x) (Not y))) = Proof $ Not (Or x y)
ruleDeMorgan (Proof (Not (Or x y))) = Proof $ And (Not x) (Not y)
ruleDeMorgan x = x

-- Switcheroo
ruleSwitcheroo :: Proof (PropCalc a) -> Proof (PropCalc a)
ruleSwitcheroo (Proof (Or x y)) = Proof $ Imp (Not x) y
ruleSwitcheroo (Proof (Imp (Not x) y)) = Proof $ Or x y
ruleSwitcheroo x = x
