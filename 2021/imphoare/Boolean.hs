module Boolean where

import Arithmetic

data Bexp =
  BTrue
  | BFalse
  | BEq Aexp Aexp
  | BLe Aexp Aexp
  | BNot Bexp
  | BAnd Bexp Bexp
  deriving (Eq)

instance Show Bexp where
  show BTrue  = "TRUE"
  show BFalse = "FALSE"
  show (BEq x y) = show x ++ " = " ++ show y
  show (BLe x y) = show x ++ " <= " ++ show y
  show (BNot x) = "! (" ++ show x ++ ")"
  show (BAnd x y) = show x ++ " && " ++ show y

boptimize :: Bexp -> Bexp
boptimize (BEq (ANum a1) (ANum a2)) = if a1 == a2 then BTrue else BFalse
boptimize (BEq (AId v1) (AId v2))   = if v1 == v2 then BTrue else BFalse
boptimize (BNot BTrue)         = BFalse
boptimize (BNot BFalse)        = BTrue
boptimize (BAnd BFalse _)      = BFalse
boptimize (BAnd BTrue b2)      = b2
boptimize x                    = x
