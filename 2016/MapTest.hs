map' :: (a -> b) -> [a] -> [b]
map' f (x:xs) = (f x) : map' f xs
map' _ [] = []

{-
(map' . map) x = map' (map' x)


x :: a -> b
map' x :: [a] -> [b]

map' :: (a -> b) -> [a] -> [b]

map' (map' x) :: 

let a = [a] and b = [b] to get

map' (map' x) :: [[a]] -> [[b]]
-}
