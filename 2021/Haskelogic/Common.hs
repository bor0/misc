module Common where

data Pos = GoLeft | GoRight deriving (Eq)

type Path = [Pos]
