-- Towards Hoare logic for a small imperative language in Haskell
-- https://bor0.wordpress.com/2021/01/18/towards-hoare-logic-for-a-small-imperative-language-in-haskell/
module Main where

import Arithmetic
import Boolean
import Command
import Data.Maybe (fromJust)
import Hoare
import qualified Data.Map as M

-- Calculate factorial of X
factX =
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

factAssertion f = f
  (BEq (ANum 5) (AId 'X'))
  factX
  (BEq (ANum 120) (AId 'Y'))

main = do
  -- Arithmetic language example
  putStrLn $ show (APlus (AId 'X') (ANum 5)) ++ " = " ++ show (aeval (M.fromList [('X', 5)]) (APlus (AId 'X') (ANum 5)))
  putStrLn $ "Optimize (context-less) " ++ show (APlus (AId 'X') (ANum 5)) ++ " = " ++ show (aoptimize (APlus (AId 'X') (ANum 5)))
  putStrLn $ "Optimize (context-less) " ++ show (APlus (ANum 2) (ANum 5)) ++ " = " ++ show (aoptimize (APlus (ANum 2) (ANum 5)))
  -- Boolean language example
  putStrLn $ show (BEq (AId 'X') (ANum 5)) ++ " = " ++ show (beval (M.fromList [('X', 5)]) (BEq (AId 'X') (ANum 5)))
  putStrLn $ "Optimize (context-less) " ++ show (BNot BTrue) ++ " = " ++ show (boptimize (BNot BTrue))
  -- Eval (run program) example
  putStrLn $ "Calculate the factorial of 5: " ++ show (eval (M.fromList [('X', 5)]) factX)
  -- Assertion example (meta)
  putStrLn $ "(PASS) Assert {X=5} factX {Y = 120} (meta): " ++ show (factAssertion (assert (M.fromList [('X', 5)])))
  putStrLn $ "(FAIL) Assert {X=5} factX {Y = 120} (meta): " ++ show (factAssertion (assert (M.fromList [('X', 4)])))
  -- Assertion example (object)
  putStrLn $ "(PASS) Assert {X=5} factX {Y = 120} (object): " ++ show (eval (M.fromList [('X', 5)]) (factAssertion CAssert))
  putStrLn $ "(FAIL) Assert {X=5} factX {Y = 120} (object): " ++ show (eval (M.fromList [('X', 4)]) (factAssertion CAssert))
  -- Hoare skip example
  let hoareSkipEg = hoareSkip CSkip (BEq (AId 'X') (ANum 3))
  putStrLn $ "Hoare skip example: " ++ show hoareSkipEg
  -- Hoare assignment example
  let hoareAssignmentEg = hoareAssignment (CAss 'X' (ANum 3)) (BEq (AId 'X') (ANum 3))
  putStrLn $ "Hoare assignment example: " ++ show hoareAssignmentEg
  -- Hoare sequence example
  putStrLn $ "Hoare sequence example: " ++ show (hoareSequence (fromJust hoareSkipEg) (fromJust hoareAssignmentEg))
  -- Hoare conditional example
  let b = BEq (AId 'X') (ANum 0)
  let p = BLe (AId 'X') (ANum 10)
  let q = BEq (AId 'X') (ANum 3)
  let c1 = CSeq (CAss 'X' (ANum 1)) (CAss 'X' (ANum 3))
  let c2 = CAss 'X' (ANum 3)
  putStrLn $ "Hoare conditional example: " ++ show (hoareConditional (HoareTriple (BAnd b p) c1 q) (HoareTriple (BAnd (BNot b) p) c2 q))
  -- Hoare while example
  putStrLn $ "Hoare while example: " ++ show (hoareWhile (HoareTriple (BAnd p b) c2 p))
