import System.IO
import Data.List.Split (splitOn, chunksOf)
import Data.Map (fromListWith, toList, Map)
import qualified Data.Map as Map

frequency :: (Ord a) => [a] -> [(a, Int)]
frequency xs = toList (fromListWith (+) [(x, 1) | x <- xs])

calculate :: Map Int Int -> Map Int Int
calculate xs =
  let newMap = Map.mapKeys (\x -> x-1) xs in
      if not (Map.member (-1) newMap)
      then newMap
      else
        let count   = newMap Map.! (-1)
            newMap' = Map.delete (-1) newMap
            newMap'' = Map.insert 6 (count + Map.findWithDefault 0 6 newMap') newMap'
            newMap''' = Map.insert 8 (count + Map.findWithDefault 0 8 newMap'') newMap''
        in newMap'''

count :: Int -> [Int] -> Int
count n xs = Map.foldl (\a b -> a + b) 0 $ start n xs

go :: Int -> Map Int Int -> Map Int Int
go 0 xs = xs
go n xs = go (n - 1) (calculate xs)

start :: Int -> [Int] -> Map Int Int
start n xs = go n $ Map.fromList $ frequency xs

parseContents contents = read ("[" ++ contents ++ "]") :: [Int]

main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let xs = parseContents contents
  print $ count 256 xs
  hClose handle
