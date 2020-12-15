import System.IO  

import Data.Char (digitToInt)
import qualified Data.Map as M

getMemory :: M.Map Int Int
getMemory = M.empty

updateMemory :: M.Map Int Int -> Int -> Int -> M.Map Int Int
updateMemory memory address value = M.insert address value memory

{-
b	bm
1	X	1
1	0	0
0	1	1
0	X	0
0	0	0
1	1	1
-}
-- Accepts a bitmask and a bitset to produce a new bitset
applyBits :: String -> String -> String
applyBits [] _ = []
applyBits (bm:bms) (b:bs) = applyBit bm b : applyBits bms bs where
  applyBit 'X' b = b
  applyBit bm  _ = bm

convert :: String -> Int
convert [] = 0
convert (x : xs) = digitToInt x + 2 * convert xs

calcNumber bm b = convert $ reverse $ applyBits bm b
