module Eval (run, runState) where

import Common
import Expr
import State
import qualified Data.Map as Map

evalExpr :: Expr -> Map.Map String Int -> State -> Int
evalExpr (Lit x) _ _ = x
evalExpr (Var "w") vars st@(State {varW = _w}) = evalExpr _w vars st
evalExpr (Var "x") vars st@(State {varX = _x}) = evalExpr _x vars st
evalExpr (Var "y") vars st@(State {varY = _y}) = evalExpr _y vars st
evalExpr (Var "z") vars st@(State {varZ = _z}) = evalExpr _z vars st
evalExpr (Var x) vars st = if Map.member x vars then vars Map.! x else error $ "Member not in map: " ++ show x
evalExpr (Add x y) vars st = evalExpr x vars st + evalExpr y vars st
evalExpr (Div x y) vars st = evalExpr x vars st `div` evalExpr y vars st
evalExpr (Mul x y) vars st = evalExpr x vars st * evalExpr y vars st
evalExpr (Mod x y) vars st = snd $ evalExpr x vars st `divMod` evalExpr y vars st
evalExpr (Eql x y) vars st = if evalExpr x vars st == evalExpr y vars st then 1 else 0

parse :: String -> Expr
parse str = go (words str) where
  go [f, v, y] = let y' = parseNumberOrVar y in Set (Var v) $ getFunction f (Var v) y'
  go ["inp", v] = Set (Var v) Input

eval :: State -> Expr -> Map.Map String Int -> State
eval st@(State {varW = _w, varX = _x, varY = _y, varZ = _z, inputs = _inputs}) expr vars = go expr where
  go (Set (Var "w") Input) = st { varW = Lit $ vars Map.! head _inputs, inputs = tail _inputs }
  go (Set (Var "x") Input) = st { varW = Lit $ vars Map.! head _inputs, inputs = tail _inputs }
  go (Set (Var "y") Input) = st { varW = Lit $ vars Map.! head _inputs, inputs = tail _inputs }
  go (Set (Var "z") Input) = st { varW = Lit $ vars Map.! head _inputs, inputs = tail _inputs }
  go (Set (Var "w") y) = st { varW = Lit $ evalExpr y vars st }
  go (Set (Var "x") y) = st { varX = Lit $ evalExpr y vars st }
  go (Set (Var "y") y) = st { varY = Lit $ evalExpr y vars st }
  go (Set (Var "z") y) = st { varZ = Lit $ evalExpr y vars st }

evalMany :: [Expr] -> State -> Map.Map String Int -> State
evalMany [] st _ = st
evalMany (x:xs) st inputs = evalMany xs (eval st x inputs) inputs

evalState :: State -> Map.Map String Int -> State
evalState st@(State {varW = _w, varX = _x, varY = _y, varZ = _z}) vars =
  st {
    varW = Lit $ evalExpr _w vars st,
    varX = Lit $ evalExpr _x vars st,
    varY = Lit $ evalExpr _y vars st,
    varZ = Lit $ evalExpr _z vars st
  }

run program vars = evalMany (map parse program) initialState (createMap vars)
runState state vars = evalState state (createMap vars)
