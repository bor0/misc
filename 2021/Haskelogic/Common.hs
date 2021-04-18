module Common where

data Pos = GoLeft | GoRight deriving (Eq)

type Path = [Pos]

-- Don't use this constructor directly. You should only construct proofs given the rules.
newtype Proof a = Proof a deriving (Eq)

instance (Show a) => Show (Proof a) where
  show (Proof a) = "⊢ " ++ show a

fromProof :: Proof a -> a
fromProof (Proof a) = a
