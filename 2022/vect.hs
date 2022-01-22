-- Mostly from https://github.com/bmsherman/haskell-vect/blob/master/Data/Vect.hs
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import Data.Type.Equality ((:~:) (Refl), gcastWith)
import GHC.Types (Type)

infixr 5 :.

-- Haskell can't deduce a lot about Ints, so use a Nat (we'll use type operators to help Haskell deduce stuff)
data Nat = Z | S Nat deriving (Show)

-- Vector implementation
data Vect :: Nat -> Type -> Type where
  Nil  :: Vect Z a
  (:.) :: a -> Vect n a -> Vect (S n) a

instance Show a => Show (Vect n a) where
  show Nil       = "[]"
  show (x :. xs) = show x ++ " :: " ++ show xs

-- Implement addition for Nat
type family (m :: Nat) :+ (n :: Nat) :: Nat where
  Z :+ n = n
  S m :+ n = S (m :+ n)

-- Example operators
len :: Vect n a -> Nat
len Nil = Z
len (x :. xs) = S (len xs)

tl :: Vect (S n) a -> Vect n a
tl (x :. xs) = xs

hd :: Vect (S n) a -> a
hd (x :. xs) = x

app :: Vect m a -> Vect n a -> Vect (m :+ n) a
app Nil ys = ys
app (x :. xs) ys = x :. app xs ys

-- Example proofs
plusSuccRightSucc :: Vect n a -> Vect m a
  -> Vect (S (n :+ m)) a :~: Vect (n :+ S m) a
plusSuccRightSucc Nil ys = Refl
plusSuccRightSucc (x :. xs) ys = gcastWith (plusSuccRightSucc xs ys) Refl

nPlusZIsN :: Vect n a -> Vect n a :~: Vect (n :+ Z) a
nPlusZIsN Nil = Refl
nPlusZIsN (x :. xs) = gcastWith (nPlusZIsN xs) Refl

rev :: Vect n a -> Vect n a
rev zs = gcastWith (nPlusZIsN zs) (go Nil zs) where
  go :: Vect m xs -> Vect n xs -> Vect (n :+ m) xs
  go acc Nil = acc
  go acc (x :. xs) = gcastWith (plusSuccRightSucc xs acc) (go (x :. acc) xs)

-- Vectors
v1 :: Vect (S (S Z)) Integer
v1 = 1 :. 2 :. Nil

v2 = 3 :. 4 :. 5 :. Nil
