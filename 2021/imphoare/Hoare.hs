module Hoare where

import Arithmetic
import Boolean
import Command

data HoareTriple =
  HoareTriple Bexp Command Bexp

instance Show HoareTriple where
  show (HoareTriple pre c post) = "{" ++ show pre ++ "} " ++ show c ++ " {" ++ show post ++ "}"

-- | Hoare skip rule
hoareSkip :: Command -> Bexp -> Maybe HoareTriple
hoareSkip CSkip q = Just $ HoareTriple q CSkip q
hoareSkip _ _     = Nothing

-- | Hoare assignment rule
hoareAssignment :: Command -> Bexp -> Maybe HoareTriple
hoareAssignment (CAss v e) q = Just $ HoareTriple (substAssignment (boptimize q) (aoptimize e) v) (CAss v e) q
hoareAssginment _ _          = Nothing

-- Q[E/V] is the result of replacing in Q all occurrences of V by E
substAssignment :: Bexp -> Aexp -> Char -> Bexp
substAssignment q@(BEq (AId x) y) e v
  | x == v    = BEq e y
  | otherwise = q
substAssignment q@(BEq x (AId y)) e v
  | y == v    = BEq e (AId y)
  | otherwise = q
substAssignment q _ _ = q

-- | Hoare sequence rule
hoareSequence :: HoareTriple -> HoareTriple -> Maybe HoareTriple
hoareSequence (HoareTriple p c1 q1) (HoareTriple q2 c2 r)
  | boptimize q1 == boptimize q2 = Just $ HoareTriple p (CSeq c1 c2) r
  | otherwise                    = Nothing

-- | Hoare conditional rule
hoareConditional :: HoareTriple -> HoareTriple -> Maybe HoareTriple
hoareConditional (HoareTriple (BAnd b1 p1) c1 q1) (HoareTriple (BAnd (BNot b2) p2) c2 q2)
  | boptimize b1 == boptimize b2 &&
    boptimize p1 == boptimize p2 &&
    boptimize q1 == boptimize q2 = Just $ HoareTriple p1 (CIfElse b1 c1 c2) q1
hoareConditional (HoareTriple (BAnd p1 b1) c1 q1) (HoareTriple (BAnd (BNot p2) b2) c2 q2)
  | boptimize b1 == boptimize b2 &&
    boptimize p1 == boptimize p2 &&
    boptimize q1 == boptimize q2 = Just $ HoareTriple p1 (CIfElse b1 c1 c2) q1
  | otherwise                    = Nothing
hoareConditional _ _ = Nothing

-- | Hoare while rule
hoareWhile :: HoareTriple -> Maybe HoareTriple
hoareWhile (HoareTriple (BAnd p1 b) c p2)
  | p1 == p2  = Just $ HoareTriple p1 (CWhile b c) (BAnd (BNot b) p2)
  | otherwise = Nothing
hoareWhile _ = Nothing
