import Test.QuickCheck

data MyNat = One | S MyNat deriving (Show)
data MyInt = P MyNat | N MyNat | Zero deriving (Show)

succ' :: MyInt -> MyInt
succ' (P x)     = P (S x)
succ' (N (S x)) = N x
succ' (N One)   = Zero
succ' Zero      = P One

pred' :: MyInt -> MyInt
pred' (N x)     = N (S x)
pred' (P (S x)) = P x
pred' (P One)   = Zero
pred' Zero      = N One

add' :: MyInt -> MyInt -> MyInt
add' a Zero  = a
add' a (P x) = succ' $ add' a $ pred' $ P x
add' a (N x) = pred' $ add' a $ succ' $ N x

sub' :: MyInt -> MyInt -> MyInt
sub' a Zero  = a
sub' a (P x) = pred' $ sub' a $ pred' $ P x
sub' a (N x) = succ' $ sub' a $ succ' $ N x

toInt :: MyInt -> Int
toInt Zero    = 0
toInt (P One) = 1
toInt (N One) = -1
toInt (P (S x)) = 1 + toInt (P x)
toInt (N (S x)) = toInt (N x) - 1

toMyInt :: Int -> MyInt
toMyInt 0    = Zero
toMyInt 1    = P One
toMyInt (-1) = N One
toMyInt x
    | x <= 0    = N $ go (-x)
    | otherwise = P $ go x
    where go 1 = One
          go x = S $ go (x - 1)

instance Eq MyInt where
    x == y = (toInt x) == (toInt y)

instance Ord MyInt where
    compare x y = compare (toInt x) (toInt y)

prop_add :: Int -> Int -> Bool
prop_add x y = x + y == toInt (add' (toMyInt x) (toMyInt y))

prop_sub :: Int -> Int -> Bool
prop_sub x y = x - y == toInt (sub' (toMyInt x) (toMyInt y))

main = do
    quickCheck (withMaxSuccess 1000 prop_add)
    quickCheck (withMaxSuccess 1000 prop_sub)
