module State (calcState, initialState, State(..)) where

import Common
import Expr
import qualified Data.Map as Map

data State = State {
  varW :: Expr,
  varX :: Expr,
  varY :: Expr,
  varZ :: Expr,
  inputs :: [String]
} deriving (Eq, Show)

stringToState :: State -> String -> State
stringToState st@(State {varW = _w, varX = _x, varY = _y, varZ = _z, inputs = _inputs}) str = go (words str) where
  go ["inp", "w"] = st { varW = Var $ head _inputs, inputs = tail _inputs }
  go ["inp", "x"] = st { varX = Var $ head _inputs, inputs = tail _inputs }
  go ["inp", "y"] = st { varY = Var $ head _inputs, inputs = tail _inputs }
  go ["inp", "z"] = st { varZ = Var $ head _inputs, inputs = tail _inputs }
  go [f, "w", y] = let y' = parseNumberOrVar y in st { varW = getFunction f _w (parse y') }
  go [f, "x", y] = let y' = parseNumberOrVar y in st { varX = getFunction f _x (parse y') }
  go [f, "y", y] = let y' = parseNumberOrVar y in st { varY = getFunction f _y (parse y') }
  go [f, "z", y] = let y' = parseNumberOrVar y in st { varZ = getFunction f _z (parse y') }
  parse (Var "w") = _w
  parse (Var "x") = _x
  parse (Var "y") = _y
  parse (Var "z") = _z
  parse x = x

calcState :: [String] -> State
calcState = foldl stringToState initialState

initialState :: State
initialState = State (Lit 0) (Lit 0) (Lit 0) (Lit 0) varNames
