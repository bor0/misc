import System.IO  
import Control.Monad
import Data.Maybe
import Data.List

-- This is the only necessary logical part to finish the task. the remaining functions are for parsing.
isValidPartOne :: Int -> Int -> Char -> [Char] -> Bool
isValidPartOne min max c s = let cnt = length $ filter (== c) s in min <= cnt && cnt <= max

isValidPartTwo :: Int -> Int -> Char -> [Char] -> Bool
isValidPartTwo min max c s = let (first, second) = (s !! (min - 1), s !! (max - 1)) -- Zero index
                              in (first == c && second /= c) || (first /= c && second == c)
--

main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let passwords = lines contents
  print $ length $ filter (== True) $ map (\x -> parseAndCheckLine isValidPartOne x) $ passwords
  print $ length $ filter (== True) $ map (\x -> parseAndCheckLine isValidPartTwo x) $ passwords
  hClose handle   

parseAndCheckLine f s = let
  line = words s
  dashIndex = fromMaybe 0 $ elemIndex '-' (head line)
  (minS, maxS) = splitAt dashIndex (head line)
  (min, max) = (read minS :: Int, read (tail maxS) :: Int)
  in
  f min max (head $ line !! 1) $ line !! 2
