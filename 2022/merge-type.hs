{-# LANGUAGE DataKinds #-}
{-# LANGUAGE StandaloneKindSignatures #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

import GHC.TypeLits

type MergeHelper :: [Nat] -> [Nat] -> Ordering -> [Nat]
type family MergeHelper xs ys o where
  MergeHelper (x:xs) (y:ys) 'LT = x : Merge xs (y:ys)
  MergeHelper (x:xs) (y:ys) gq  = y : Merge (x:xs) ys

type Merge :: [Nat] -> [Nat] -> [Nat]
type family Merge xs ys where
  Merge '[]  ys = ys
  Merge xs  '[] = xs
  Merge (x:xs) (y:ys) = MergeHelper (x:xs) (y:ys) (CmpNat x y)

-- > :set -XDataKinds
-- > :kind! Merge '[1, 3, 5] '[2, 3, 4]
