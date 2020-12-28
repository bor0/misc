-- Haskell variadic functions (e.g. liftA1, liftA2, ..., liftAN)
class SumRes r where 
    sumOf :: Integer -> r

instance SumRes Integer where
    sumOf = id

instance (Integral a, SumRes r) => SumRes (a -> r) where
    sumOf x = sumOf . (x +) . toInteger

-- sumOf 1 2 :: Integer