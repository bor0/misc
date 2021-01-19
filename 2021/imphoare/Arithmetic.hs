module Arithmetic where

data Aexp =
  ANum Integer
  | AId Char
  | APlus Aexp Aexp
  | AMinus Aexp Aexp
  | AMult Aexp Aexp
  deriving (Eq)

instance Show Aexp where
  show (ANum x) = show x
  show (AId x)  = [x]
  show (APlus x y) = show x ++ " + " ++ show y
  show (AMinus x y) = show x ++ " - " ++ show y
  show (AMult x y) = show x ++ " * " ++ show y

aoptimize :: Aexp -> Aexp
aoptimize (APlus (ANum a1) (ANum a2))  = ANum (a1 + a2)
aoptimize (AMinus (ANum a1) (ANum a2)) = ANum (a1 - a2)
aoptimize (AMult (ANum a1) (ANum a2))  = ANum (a1 * a2)
aoptimize x                            = x
