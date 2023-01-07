module Command where

import Arith
import qualified Data.Map as M
import Data.List (find)

-- Command set
data Command =
  Assign Variable Arith
  deriving (Eq, Show)

-- | Evaluate a set of commands, given a context
eval :: Context -> [Command] -> Either String Context
eval ctx ((Assign v a):cs) = aeval ctx a >>= \a -> eval (M.insert v a ctx) cs
eval ctx [] = Right ctx

-- | Calculate all closed expressions of a list of commands
calcClosedExprs :: [Command] -> OrderedContext
calcClosedExprs commands = go commands []
  where
  go ((Assign v a):cs) rs = go cs (substArithMulti v a rs)
  go [] rs = rs

-- | Calculate a closed-form expression for a single variable (e.g. if 'Y' is treated as output)
calcClosedExpr :: Variable -> OrderedContext -> Maybe Arith
calcClosedExpr var rs = find (\x -> fst x == var) (reverse rs) >>= Just . snd
