-- Operator so specijalni znaci raboti samo infix
data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord)

(+++) :: List a -> List a -> List a
Empty +++ ys = ys
(x :-: xs) +++ ys = x :-: (xs +++ ys)

(!!!) :: List a -> Int -> a
(x :-: xs) !!! 0 = x
(x :-: xs) !!! n = xs !!! (n - 1)
_ !!! n | n < 0 = error ("negative index")
Empty !!! n = error("index too large")

headList' :: List a -> a
headList' Empty = error("empty list")
headList' (x :-: _) = x

tailList' :: List a -> List a
tailList' Empty = error("empty list")
tailList' (_ :-: xs) = xs

x1 = 1 :-: (2 :-: Empty)
y1 = 3 :-: (4 :-: Empty)

-- x1 +++ y1

-- Ekvivalenten primer so prefix
data List2 a = LEmpty | Cons a (List2 a) deriving (Show, Read, Eq, Ord)

add' :: List2 a -> List2 a -> List2 a
add' LEmpty ys = ys
add' (Cons x xs) ys = Cons x (add' xs ys)

find' :: List2 a -> Int -> a
find' (Cons x xs) 0 = x
find' (Cons x xs) n = find' xs (n - 1)
find' _ n | n < 0 = error("negative index")
find' LEmpty _ = error("index too large")

headList2' :: List2 a -> a
headList2' LEmpty = error("empty list")
headList2' (Cons x _) = x

tailList2' :: List2 a -> List2 a
tailList2' LEmpty = error("empty list")
tailList2' (Cons _ xs) = xs

x2 = Cons 1 (Cons 2 (LEmpty))
y2 = Cons 3 (Cons 4 (LEmpty))

filter' :: (a -> Bool) -> List2 a -> List2 a
filter' _ LEmpty = LEmpty
filter' x (Cons y ys) = if x y then (Cons y (filter' x ys)) else filter' x ys

quicksort [] = []
quicksort (x:xs) = quicksort ys ++ [x] ++ quicksort zs
                   where
                      ys = filter (<=x) xs
                      zs = filter (>x) xs

quicklolsort :: (Ord a) => List2 a -> List2 a
quicklolsort LEmpty = LEmpty
quicklolsort (Cons x xs) = quicklolsort ys `add'` Cons x LEmpty `add'` quicklolsort zs
                   where
                      ys = filter' (<=x) xs
                      zs = filter' (>x) xs

fromList :: [a] -> List2 a
fromList [] = LEmpty
fromList (x:xs) = Cons x (fromList xs)

toList :: List2 a -> [a]
toList LEmpty = []
toList (Cons x xs) = x : toList xs