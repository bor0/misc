import System.IO  
import Control.Monad

import Data.Maybe (isNothing, fromJust)
import Data.List (inits, tails, find)

---- Part one
-- An element in a list is invalid if no two last n numbers (preamble) sum to it.
findFirstInvalid :: [Integer] -> [Integer] -> Maybe Integer
findFirstInvalid _        []     = Nothing
findFirstInvalid preamble (x:xs) = if isElementInvalid x
                              then Just x
                              else findFirstInvalid (tail preamble ++ [x]) xs where
  isElementInvalid el = null ([x + y | x <- preamble, y <- preamble, x + y == el, x /= y])

---- Part two
-- Returns a list such that the first n elements sum up to `el`.
findSum :: Integer -> [Integer] -> Maybe [Integer]
findSum el xs = find (\xs' -> sum xs' == el) $ inits xs

-- Returns a list such that at least two consecutive elements starting at any index sum up to `el`
findSum' :: Integer -> [Integer] -> Maybe [Integer]
findSum' el xs = let xs'    = init $ init $ tails xs -- drop last two
                     xs_sum = find (not . null . findSum el) xs' in
                     maybe Nothing (findSum el) xs_sum

-- `findSum` is slow because of the strictness of `inits`.
-- Here's an equivalent, faster implementation:
findSum'' :: Integer -> [Integer] -> [Integer] -> Maybe [Integer]
findSum'' _  []       [] = Nothing
findSum'' _  cl       [] = Just cl
findSum'' el cl (x : xs)
    | x == el   = Just $ x : cl
    | x > el    = Nothing
    | otherwise = findSum'' (el - x) (x : cl) xs


main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let entries = map read $ lines contents
  let (preamble, l) = splitAt 25 entries
  let s = findSum' (fromJust $ findFirstInvalid preamble l) l
  print $ findFirstInvalid preamble l
  print s
  print $ minimum (fromJust s) + maximum (fromJust s)
  hClose handle   
