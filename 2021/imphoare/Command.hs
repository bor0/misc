module Command where

import Arithmetic
import Boolean
import Utils
import qualified Data.Map as M

type Context = M.Map Char Integer

data Command =
  CSkip
  | CAss Char Aexp
  | CSeq Command Command
  | CIfElse Bexp Command Command
  | CWhile Bexp Command
  | CAssert Bexp Command Bexp

instance Show Command where
  show CSkip = ";"
  show (CAss x y) = [x] ++ " := " ++ show y ++ ";"
  show (CSeq x y) = show x ++ ";" ++ show y ++ ";"
  show (CIfElse x y z) = "(If (" ++ show x ++ ") Then (" ++ show y ++ ") Else (" ++ show z ++ "));"
  show (CWhile x y) = "(While (" ++ show x ++ ") Do {" ++ show y ++ "});"
  show (CAssert x y z) = "(Assert {" ++ show x ++ "} (" ++ show y ++ ") {" ++ show z ++ "});"

aeval :: Context -> Aexp -> Integer
aeval ctx (AId v)        = ctx M.! v -- element may not exist
aeval ctx (ANum n)       = n
aeval ctx (APlus a1 a2)  = aeval ctx a1 + aeval ctx a2
aeval ctx (AMinus a1 a2) = aeval ctx a1 - aeval ctx a2
aeval ctx (AMult a1 a2)  = aeval ctx a1 * aeval ctx a2

beval :: Context -> Bexp -> Bool
beval ctx BTrue        = True
beval ctx BFalse       = False
beval ctx (BEq a1 a2)  = aeval ctx a1 == aeval ctx a2
beval ctx (BLe a1 a2)  = aeval ctx a1 <= aeval ctx a2
beval ctx (BNot b1)    = not (beval ctx b1)
beval ctx (BAnd b1 b2) = beval ctx b1 && beval ctx b2

eval :: Context -> Command -> Either String Context
eval ctx CSkip             = Right ctx
eval ctx (CAss c v)        = Right $ M.insert c (aeval ctx v) ctx
eval ctx (CSeq c1 c2)      = let ctx' = eval ctx c1 in whenRight ctx' (\ctx'' -> eval ctx'' c2)
eval ctx (CIfElse b c1 c2) = eval ctx $ if beval ctx b then c1 else c2
eval ctx (CWhile b c)      = if beval ctx b
                              then let ctx' = eval ctx c in whenRight ctx' (\ctx'' -> eval ctx'' (CWhile b c))
                              else Right ctx
eval ctx (CAssert b1 c b2) =
  if beval ctx b1
  then whenRight (eval ctx c)
       (\ctx'' -> if beval ctx'' b2
                  then Right ctx''
                  else Left "Post-condition does not match!")
  else Left "Pre-condition does not match!"

assert :: Context -> Bexp -> Command -> Bexp -> Bool
assert ctx boolPre cmd boolPost = let res = eval ctx cmd in go res
  where
  go (Right ctx') = beval ctx boolPre && beval ctx' boolPost
  go _            = False
