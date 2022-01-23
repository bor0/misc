{-# LANGUAGE DataKinds #-}
{-# LANGUAGE StandaloneKindSignatures #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

import GHC.TypeLits -- For Nat
import GHC.TypeNats (Div)

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

type Take :: Nat -> [Nat] -> [Nat]
type family Take xs n where
  Take 0 xs  = '[]
  Take n '[] = '[]
  Take n (x:xs) = x : Take (n - 1) xs

-- > :set -XDataKinds
-- > :kind! Take 3 (Merge '[1, 3, 5] '[2, 3, 4])

type Drop :: Nat -> [Nat] -> [Nat]
type family Drop xs n where
  Drop n '[] = '[]
  Drop 0 xs  = xs
  Drop n (x:xs) = Drop (n - 1) xs

-- > :set -XDataKinds
-- > :kind! Drop 3 (Merge '[1, 3, 5] '[2, 3, 4])

type Length :: [Nat] -> Nat
type family Length xs where
  Length '[] = 0
  Length (x:xs) = 1 + Length xs

-- > :set -XDataKinds
-- > :kind! Length '[1, 2, 3]

type MergeSort :: [Nat] -> [Nat]
type family MergeSort xs where
  MergeSort '[x] = '[x]
  MergeSort xs = Merge (MergeSort (Take (Div (Length xs) 2) xs)) (MergeSort (Drop (Div (Length xs) 2) xs))

-- > :set -XDataKinds
-- > :kind! Merge '[1, 3, 2, 4]
