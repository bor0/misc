--load test.hs
-- test let

divideList :: (Int, [Int]) -> [Int]
divideList (0, n) = []
divideList (m, n) = divideList(m-1, n) ++ [(n !! (m-1))]

aaa = let y = 1+2
          z = 3+4
          in  y+z+1

prvideset = let y = 10
                in sumN(10)

sumN :: Int -> Int
sumN 0 = 0
sumN n = n + sumN(n-1)

productN :: Int -> Int
productN 0 = 1
productN n = n * productN(n-1)

lolIterate :: Int -> [Int]
lolIterate n = [ 2*x | x <- listTest(n)]

listTest :: Int -> [Int]
listTest 0 = [] --[0] to include 0
listTest n = listTest(n-1) ++ [n]

smartReturnN :: Int -> String
smartReturnN n
  | n > 0     = show(listTest(n)) ++ " -> " ++ show(listTest(n) !! (n-1))
  | otherwise = "why"

reverselistTest :: Int -> [Int]
reverselistTest 0 = [] --[0] to include 0
reverselistTest n = n : reverselistTest(n-1)

comboTest :: Int -> [Int]
comboTest n = listTest(n ) ++ reverselistTest(n )

isEven :: Int -> Bool
isEven 0 = True
isEven n = not(isEven(n-1))

equalityCheck :: (Float, Float) -> String
equalityCheck (m, n)
  | m > n   = "Greater"
  | m < n   = "Lesser"
  | otherwise = "Equal.  Squared is " ++ a
  where
    a = show(m*n)

numberTest :: Int -> String
numberTest 0 = "t"
numberTest 1 = "s" ++ numberTest(0)
numberTest 2 = "e" ++ numberTest(1)
numberTest 3 = "T" ++ numberTest(2)
numberTest n = y
  where y = numberTest(n-1) ++ "!"