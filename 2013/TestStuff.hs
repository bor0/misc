dec2binTail' :: Int -> [Int] -> [Int]
dec2binTail' 0 q = q
dec2binTail' p q = dec2binTail' (p `div` 2) (p `mod` 2 : q)

dec2binTail :: Int -> String
dec2binTail q = (dec2binTail' q []) >>= show

callmultiple :: (a -> a) -> a -> a
callmultiple f x = f (f x)

maptry :: (a -> b) -> [a] -> [b
maptry f x = [f a | a <- x]

maprec :: (a -> a) -> [a] -> [a]
maprec _ [] = []
maprec f (x:xs) = f x : maprec f xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
    | p x = x : filter' p xs
    | otherwise = filter' p xs

lolkek :: Int -> Int
lolkek x
    | x > 3 = 5
    | otherwise = 7

--[ x | x <- [100000,99999..1], x `mod` 3829 == 0]

maxlist :: [Int] -> Int
maxlist [] = 0
maxlist (x:xs) = max x (maxlist xs)

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' _ [] = []
takeWhile' p (x:xs)
    | p x = x : takeWhile' p xs
    | otherwise = []