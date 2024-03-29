import System.IO  
import Control.Monad

import Data.List

-- Part one
findRowCol :: String -> Int
findRowCol s = head $ go s [0..2^length s - 1] where
  go (x:xs) l
      | x `elem` ['F', 'L'] = go xs (take (length l `div` 2) l)
      | x `elem` ['B', 'R'] = go xs (drop (length l `div` 2) l)
      | otherwise = l
  go _ l = l

calcSeatId :: String -> Int
calcSeatId s = let row = findRowCol $ take 7 s
                   col = findRowCol $ drop 7 s
                in row * 8 + col

-- Part two
findMySeat :: [Int] -> Int
findMySeat l = head $ [minimum l..maximum l] \\ l

main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let entries = lines contents
  print $ maximum $ map calcSeatId entries
  print $ findMySeat $ map calcSeatId entries
  hClose handle   

-- Alternative implementation of `findRowCol`, but less readable (to me)
findRowCol' :: String -> Int
findRowCol' s = go s 0 (2^length s - 1) where
  go (x:xs) lb ub
      | x `elem` ['F', 'L'] = go xs lb (lb + floor (fromIntegral (ub - lb) / 2))
      | x `elem` ['B', 'R'] = go xs (lb + ceiling (fromIntegral (ub - lb) / 2)) ub
      | otherwise = lb
  go _ lb ub = lb
