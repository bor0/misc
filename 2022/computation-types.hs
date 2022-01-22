-- From https://serokell.io/blog/type-families-haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE StandaloneKindSignatures #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

-- | Append example:
append :: forall a. [a] -> [a] -> [a]    -- type signature
append []     ys = ys                    -- clause 1
append (x:xs) ys = x : append xs ys      -- clause 2

type Append :: forall a. [a] -> [a] -> [a]  -- kind signature
type family Append xs ys where              -- header
  Append '[]    ys = ys                     -- clause 1
  Append (x:xs) ys = x : Append xs ys       -- clause 2

eg1 = append [1, 2, 3] [4, 5, 6]
-- > :set -XDataKinds
-- > :kind! Append [1, 2, 3] [4, 5, 6]

-- | Not example:
not :: Bool -> Bool
not True = False
not False = True

type Not :: Bool -> Bool
type family Not a where
  Not True = False
  Not False = True

eg2 = Main.not False
-- > :set -XDataKinds
-- > :kind! Not False

-- | FromMaybe example:
fromMaybe :: a -> Maybe a -> a
fromMaybe d Nothing = d
fromMaybe _ (Just x) = x

type FromMaybe :: a -> Maybe a -> a
type family FromMaybe d x where
  FromMaybe d Nothing = d
  FromMaybe _ (Just x) = x

eg3 = fromMaybe 3 Nothing
-- > :set -XDataKinds
-- > :kind! FromMaybe 3 Nothing

-- | Fst example:
fst :: (a, b) -> a
fst (x, _) = x

type Fst :: (a, b) -> a
type family Fst t where
  Fst '(x, _) = x

eg4 = Main.fst (1, 2)
-- > :set -XDataKinds
-- > :kind! Fst '(1, 2)
