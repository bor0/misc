import System.IO

import Data.Map (fromListWith, toList, Map)
import qualified Data.Map as Map

populate :: Map Int Int -> Map Int Int
populate theMap =
  let newMap    = Map.mapKeys (\x -> x - 1) theMap
      count     = Map.findWithDefault 0 (-1) newMap
      newMap'   = Map.delete (-1) newMap
      newMap''  = Map.insertWith (+) 6 count newMap'
      newMap''' = Map.insertWith (+) 8 count newMap''
      in newMap'''

start :: Int -> [Int] -> Map Int Int
start n xs = go n $ Map.fromList $ frequency xs
  where
  go n xs = iterate populate xs !! n
  frequency xs = toList (fromListWith (+) [(x, 1) | x <- xs])

count = Map.foldl (+) 0

-- Parsing and processing
parseContents contents = read ("[" ++ contents ++ "]") :: [Int]

main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let xs = parseContents contents
  print $ count (start 256 xs)
  hClose handle
