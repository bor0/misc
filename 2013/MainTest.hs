-- Needed for hFlush
import System.IO

-- compile with: ghc main.hs
main = do putStrLn "Input two numbers to get their sum"
          hFlush stdout
          x <- getDouble ; y <- getDouble
          putStr "sum = " ; print (x+y)
          putStr "power(x,y) = " ; print (pow x y)
          putStrLn "Input an integer to get its factorial"
          z <- getInt
          putStr "fact = " ; print (factorial' z)
          putStrLn "Input a string to get lowercase and uppercase conversion of it"
          str <- getString
          putStr "lowercase count = " ; print (length (countCase str ['a'..'z']))
          putStr "uppercase count = " ; print (length (countCase str ['A'..'Z']))
          putStr "all uppercase = " ; print (allUpperCase str)
          putStr "all lowercase = " ; print (allLowerCase str)
          putStr "invert case = " ; print (invertCase str)
          putStr "string starts with 'test': " ; putStrLn (if isPrefixOf "test" str then "yes" else "no")

getInt :: IO Int
getInt = readLn

getDouble :: IO Double
getDouble = readLn

getString :: IO String
getString = getLine

countCase :: String -> String -> String
countCase m n = [ x | x <- m, x `elem` n]

------------------------
findIndex' :: String -> Char -> Int -> Int
findIndex' [] _ _ = -1
findIndex' (x:xs) y z = if (x == y) then z else findIndex' xs y z+1

findIndex :: String -> Char -> Int
findIndex x y = findIndex' x y 0

allUpperCase :: String -> String
allUpperCase [] = []
allUpperCase (x:xs) = ((['A'..'Z']++['A'..'Z']) !! (findIndex (['a'..'z']++['A'..'Z']) x)) : allUpperCase(xs)

allLowerCase :: String -> String
allLowerCase [] = []
allLowerCase (x:xs) = ((['a'..'z']++['a'..'z']) !! (findIndex (['A'..'Z']++['a'..'z']) x)) : allLowerCase(xs)

invertCase :: String -> String
invertCase [] = []
invertCase (x:xs) = ((['a'..'z']++['A'..'Z']) !! (findIndex (['A'..'Z']++['a'..'z']) x)) : invertCase(xs)

fixpoint f x = f (fixpoint f) x
factorial' = fixpoint (\ff n -> if n == 0 then 1 else n * ff(n-1))

pow :: Double -> Double -> Double
pow x 0 = 1
pow x y = x * pow x (y-1)

dec2binTail' :: Int -> [Int] -> [Int]
dec2binTail' 0 q = q
dec2binTail' p q = dec2binTail' (p `div` 2) (p `mod` 2 : q)

dec2binTail :: Int -> [Int]
dec2binTail q = dec2binTail' q []

dec2bin :: Int -> [Int]
dec2bin 0 = []
dec2bin p = dec2bin (p `div` 2) ++ [(p `mod` 2)]

isPrefixOf              :: (Eq a) => [a] -> [a] -> Bool
isPrefixOf [] _         =  True
isPrefixOf _  []        =  False
isPrefixOf (x:xs) (y:ys)=  x == y && isPrefixOf xs ys

test :: (Num a) => a -> a
test x = x + x

test' :: (a -> b) -> (a -> b)
test' p = p

max' :: Int -> Int -> Int
max' a b = if (a > b) then a else b

max'' :: Int -> Int -> Int
max'' a b = (test' max') a b

zip' :: [a] -> [b] -> [(a, b)]
zip' (x:xs) (y:ys) = (x, y) : zip' xs ys
zip' _ _ = []

repeat' :: a -> [a]
repeat' x = x:repeat' x