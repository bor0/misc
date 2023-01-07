module Frac where

-- A fraction is just a product of two integers
data Frac = Frac Integer Integer deriving (Eq, Show)

-- | Fractional add
fplus :: Frac -> Frac -> Frac
fplus (Frac a u) (Frac b v) = Frac (p `div` x) (q `div` x)
  where
  p = a*v + b*u
  q = u*v
  x = gcd p q

-- | Fractional minus
fminus :: Frac -> Frac -> Frac
fminus a b = fplus a (fneg b)
  where
  fneg (Frac a b) = Frac (-a) b

-- | Fractional multiplication
fmult :: Frac -> Frac -> Frac
fmult (Frac a u) (Frac b v) = Frac (a * b) (u * v)

-- | Fractional division
fdiv :: Frac -> Frac -> Frac
fdiv a b = a `fmult` freci b
  where
  freci (Frac a b) = Frac b a
