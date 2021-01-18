-- I implemented `Imp.v` from Logical Foundations at the type level in Coq.
-- Writing it in Haskell is different though - we play more at the value level.
import qualified Data.Map as M
import Data.Maybe (fromJust)

type Context = M.Map Char Integer

data Aexp =
  ANum Integer
  | AId Char
  | APlus Aexp Aexp
  | AMinus Aexp Aexp
  | AMult Aexp Aexp
  deriving (Show, Eq)

data Bexp =
  BTrue
  | BFalse
  | BEq Aexp Aexp
  | BLe Aexp Aexp
  | BNot Bexp
  | BAnd Bexp Bexp
  deriving (Show, Eq)

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

assert :: Context -> Bexp -> Command -> Bexp -> Bool
assert ctx boolPre cmd boolPost =
  beval ctx boolPre &&
  beval (eval ctx cmd) boolPost

fact_Proof = assert
  (M.fromList [('X', 5)])
  (BEq (ANum 5) (AId 'X'))
  fact_X
  (BEq (ANum 120) (AId 'Y'))

data HoareTriple =
  HoareTriple Bexp Command Bexp
  deriving (Show)

-- Q[E/V] is the result of replacing in Q all occurrences of V by E
substAssignment :: Bexp -> Aexp -> Char -> Bexp
substAssignment q@(BEq (AId x) y) e v
  | x == v    = BEq e y
  | otherwise = q
substAssignment q@(BEq x (AId y)) e v
  | y == v    = BEq e (AId y)
  | otherwise = q
substAssignment q _ _ = q

hoareAssignment :: Command -> Bexp -> Maybe HoareTriple
hoareAssignment (CAss v e) q = Just $ HoareTriple (substAssignment q e v) (CAss v e) q
hoareAssginment _ _ = Nothing

eg1 = hoareAssignment (CAss 'X' (ANum 3)) (BEq (AId 'X') (ANum 3))

hoareSkip :: Command -> Bexp -> Maybe HoareTriple
hoareSkip (CSkip) q = Just $ HoareTriple q CSkip q
hoareSkip _ _ = Nothing

eg2 = hoareSkip CSkip (BEq (AId 'X') (ANum 3))

hoareSequence :: HoareTriple -> HoareTriple -> Maybe HoareTriple
hoareSequence (HoareTriple p c1 q1) (HoareTriple q2 c2 r)
    | q1 == q2  = Just $ HoareTriple p (CSeq c1 c2) r
    | otherwise = Nothing

eg3 = hoareSequence (fromJust eg1) (fromJust eg2)
