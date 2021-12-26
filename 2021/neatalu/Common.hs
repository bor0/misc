{-# LANGUAGE CPP #-}

module Common where

import Expr
import Text.Read (readMaybe)
import qualified Data.Map as Map

parseNumberOrVar :: String -> Expr
parseNumberOrVar x = let x' = (readMaybe x :: Maybe Int) in maybe (Var x) Lit x'

getFunction :: String -> (Expr -> Expr -> Expr)
getFunction "add" = Add
getFunction "div" = Div
getFunction "mul" = Mul
getFunction "mod" = Mod
getFunction "eql" = Eql
getFunction x = error $ "Undefined function: " ++ x

varNames :: [String]
varNames = map (\x -> [x]) "ABCDEFGHIJKLMN"

createMap :: [a] -> Map.Map String a
createMap ns = Map.fromList $ zip varNames ns
