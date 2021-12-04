import System.IO  
import Data.List.Split (splitOn, chunksOf)

data Bingo = Marked Int | Unmarked Int deriving (Show, Eq)

isMarked :: Bingo -> Bool
isMarked (Marked _) = True
isMarked _ = False

extract :: Bingo -> Int
extract (Marked x) = x
extract (Unmarked x) = x

tableAnyRowColMarked :: [Bingo] -> Bool
tableAnyRowColMarked xs =
  (any (all isMarked) $ getCols xs)
  ||
  (any (all isMarked) $ getRows xs)
  where
  getRows [] = []
  getRows xs = take 5 xs : getRows (drop 5 xs)
  getCols [] = []
  getCols xs = [ map (!! n) (chunksOf 5 xs) | n <- [0..4] ]

markNumber xs x = map (\x' -> if x' == Unmarked x then Marked x else x') xs

calculate :: [[Bingo]] -> [Int] -> Int
calculate tables (x:xs) =
  let newTables = map (`markNumber` x) tables in
  if any tableAnyRowColMarked newTables
  then let foundTable = head $ filter tableAnyRowColMarked newTables in
  x * sum (map extract (filter (not . isMarked) foundTable))
  else calculate newTables xs

-- Parsing
parseTable table = let
  newlines = splitOn "\n" table
  joined   = unwords newlines
  spaces   = splitOn " " joined
  spaces'  = filter (/= "") spaces
  joined'  = map (\x -> read x :: Int) spaces'
  joined'' = map Unmarked joined'
  in joined''

parseContents contents = let
  entries  = splitOn "\n\n" contents
  numbers  = head entries
  numbers' = map (\x -> read x :: Int) $ splitOn "," numbers
  tables   = tail entries
  tables'  = map parseTable tables
  in (numbers', tables')

-- Main
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let (numbers', tables') = parseContents contents
  print $ calculate tables' numbers'
  hClose handle   
