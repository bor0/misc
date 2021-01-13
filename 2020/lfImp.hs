-- I implemented `Imp.v` from Logical Foundations at the type level in Coq.
-- Writing it in Haskell is different though - we play more at the value level.
import qualified Data.Map as M

type Context = M.Map Char Integer

data Aexp =
  ANum Integer
  | AId Char
  | APlus Aexp Aexp
  | AMinus Aexp Aexp
  | AMult Aexp Aexp
  deriving (Show)

data Bexp =
  BTrue
  | BFalse
  | BEq Aexp Aexp
  | BLe Aexp Aexp
  | BNot Bexp
  | BAnd Bexp Bexp
  deriving (Show)

data Command =
  CSkip
  | CAss Char Aexp
  | CSeq Command Command
  | CIfElse Bexp Command Command
  | CWhile Bexp Command
  deriving (Show)

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

eval :: Context -> Command -> Context
eval ctx CSkip             = ctx
eval ctx (CAss c v)        = M.insert c (aeval ctx v) ctx
eval ctx (CSeq c1 c2)      = let ctx' = eval ctx c1 in eval ctx' c2
eval ctx (CIfElse b c1 c2) = eval ctx $ if beval ctx b then c1 else c2
eval ctx (CWhile b c)      = if beval ctx b
                             then let ctx' = eval ctx c in eval ctx' (CWhile b c)
                             else ctx

-- Calculate factorial of X
fact_X =
  -- Z := X
  let l1 = CAss 'Z' $ AId 'X'
  -- Y := 1
      l2 = CAss 'Y' (ANum 1)
  -- while (~Z = 0)
      l3 = CWhile (BNot (BEq (AId 'Z') (ANum 0))) (CSeq l4 l5)
     -- Y := Y * Z
      l4 = CAss 'Y' (AMult (AId 'Y') (AId 'Z'))
     -- Z := Z - 1
      l5 = CAss 'Z' (AMinus (AId 'Z') (ANum 1))
  in CSeq l1 (CSeq l2 l3)

fact_n n = eval (M.fromList [('X', n)]) fact_X

-- This will make fact_X more readable, but what about a proof?
-- TODO: Use QuickCheck or something as a "proof"
instance Semigroup Command where
  a <> b = CSeq a b

instance Monoid Command where
  mempty = CSkip

fact_X' = mempty
  `mappend` CAss 'Z' (AId 'X')
  `mappend` CAss 'Y' (ANum 1)
  `mappend` CWhile (BNot (BEq (AId 'Z') (ANum 0))) (mempty
     `mappend` CAss 'Y' (AMult (AId 'Y') (AId 'Z'))
     `mappend` CAss 'Z' (AMinus (AId 'Z') (ANum 1)
  ))

fact_n' n = eval (M.fromList [('X', n)]) fact_X
