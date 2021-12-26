{-# LANGUAGE CPP #-}

module Expr where

/*
#define DEBUG
*/

data Expr =
  Lit Int
  | Var String
  | Add Expr Expr
  | Div Expr Expr
  | Mul Expr Expr
  | Mod Expr Expr
  | Eql Expr Expr
  | Set Expr Expr
  | Input
  deriving
  (Eq
#ifdef DEBUG
  , Show
#endif
  )

#ifndef DEBUG
instance Show Expr where
  show (Lit x) = show x
  show (Var x) = x
  show (Add x y) = show x ++ "+" ++ show y
  show (Div x y) = "(" ++ show x ++ "/" ++ show y ++ ")"
  show (Mul x y) = "(" ++ show x ++ "*" ++ show y ++ ")"
  show (Mod x y) = "(" ++ show x ++ "%" ++ show y ++ ")"
  show (Eql x y) = "(" ++ show x ++ "=" ++ show y ++ ")"
  show (Set x y) = "(" ++ show x ++ ":=" ++ show y ++ ")"
  show Input = "IN"
#endif

optimize :: Expr -> Expr
optimize (Add (Lit 0) x) = optimize x
optimize (Add x (Lit 0)) = optimize x
optimize (Add (Lit x) (Lit y)) = Lit $ x + y
optimize (Add x y) = Add (optimize x) (optimize y)
optimize (Div x (Lit 1)) = optimize x
optimize (Div (Lit 0) x) = Lit 0
optimize (Div (Lit x) (Lit y)) = Lit $ x `div` y
optimize (Div (Div x (Lit y)) (Lit z)) = optimize $ Div (optimize x) (Lit $ y * z)
optimize (Div x y) = Div (optimize x) (optimize y)
optimize (Mul (Lit 1) x) = optimize x
optimize (Mul x (Lit 1)) = optimize x
optimize (Mul (Lit 0) x) = Lit 0
optimize (Mul x (Lit 0)) = Lit 0
optimize (Mul (Lit x) (Lit y)) = Lit $ x * y
optimize (Mul x y) = Mul (optimize x) (optimize y)
optimize (Mod x (Lit 1)) = Lit 0
optimize (Mod (Lit 0) x) = Lit 0
optimize (Mod (Lit x) (Lit y)) | y > x = Lit x
optimize (Mod (Lit x) (Lit y)) = Lit $ snd $ x `divMod` y
optimize (Mod x y) = Mod (optimize x) (optimize y)
optimize (Eql a b) = Lit $ if optimize a == optimize b then 1 else 0
optimize x = x
