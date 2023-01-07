module Arith where

import qualified Data.Map as M
import Frac

-- Variables are encoded as single character
type Variable = Char

-- Provide the language (datatype) of the arithmetic
data Arith =
  Var Variable
  | Lit Frac
  | Plus Arith Arith
  | Minus Arith Arith
  | Mult Arith Arith
  | Div Arith Arith
  deriving (Eq, Show)

-- A context is a map of variables and fractions (variable assignments with values)
type Context = M.Map Variable Frac

-- We need an ordered multimap when doing multiple substitutions
-- E.g., consider x=2+y, and y=2+x. It matters whether we subst x or y first in (x+y)
type OrderedContext = [(Variable, Arith)]

-- | Recursively evaluate an arithmetic expression, given a context
aeval :: Context -> Arith -> Either String Frac
aeval ctx (Var v)       = if M.member v ctx then Right (ctx M.! v) else Left "Element not found"
aeval ctx (Lit x)       = Right x
aeval ctx (Plus a1 a2)  = aeval ctx a1 >>= \a1 -> aeval ctx a2 >>= \a2 -> Right $ a1 `fplus` a2
aeval ctx (Minus a1 a2) = aeval ctx a1 >>= \a1 -> aeval ctx a2 >>= \a2 -> Right $ a1 `fminus` a2
aeval ctx (Mult a1 a2)  = aeval ctx a1 >>= \a1 -> aeval ctx a2 >>= \a2 -> Right $ a1 `fmult` a2
aeval ctx (Div a1 a2)   = aeval ctx a1 >>= \a1 -> aeval ctx a2 >>= \a2 -> Right $ a1 `fdiv` a2

-- | Given a variable, an expression and a value, replace all variables with the value in the expression recursively.
substArith :: Variable -> Arith -> Arith -> Arith
substArith var (Var v) value | v == var = value
substArith var (Plus a1 a2) value = Plus (substArith var a1 value) (substArith var a2 value)
substArith var (Minus a1 a2) value = Minus (substArith var a1 value) (substArith var a2 value)
substArith var (Mult a1 a2) value = Mult (substArith var a1 value) (substArith var a2 value)
substArith var (Div a1 a2) value = Div (substArith var a1 value) (substArith var a2 value)
substArith _ x _ = x

-- | Given a variable and an expression, recursively replace the expression's list of variables->exprs, returning a new list of variables->exprs
substArithMulti :: Variable -> Arith -> OrderedContext -> OrderedContext
substArithMulti v a rs = go rs v a rs
  where
  go xs v a ((v', r):rs) = go xs v (substArith v' a r) rs
  go xs v a []           = xs ++ [(v, a)]
