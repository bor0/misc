import System.IO  
import Control.Monad

type RowsCols = (Int, Int)
type Coordinate = (Int, Int)

getColsRows :: [String] -> RowsCols
getColsRows l = (length $ head l, length l)

getCoords :: RowsCols -> [Coordinate]
getCoords rc@(rows, cols) = [ (x, y) | x <- [0..rows - 1], y <- [0..cols - 1] ]

getAdjacentCoords (x, y) (rows, cols) = [ (x + dx, y + dy) |
                                          dx <- [-1..1], dy <- [-1..1],    -- All nine directions
                                          (x + dx, y + dy) /= (x, y),      -- But, avoid current position to make 8 directions
                                          x + dx >= 0 && y + dy >= 0,      -- Bounds check
                                          x + dx < rows && y + dy < cols ] -- Bounds check

---- Part one
-- Calculate adjacent values for every position in a list.
calculatePosVals :: [String] -> [(Char, String)]
calculatePosVals l = let rc@(rows, cols)     = getColsRows l
                         coords              = getCoords rc
                         getListEl (x, y)    = l !! y !! x
                         mapFuncAdj c@(x, y) = (getListEl c, map (\x -> getListEl x) $ getAdjacentCoords c rc)
                         in map mapFuncAdj coords

-- Generate new matrix based on calculated adjacent values
generateStrByPosVals :: [(Char, String)] -> String
generateStrByPosVals d = go d [] where
  go [] acc = reverse acc
  go ((c, cs):xs) acc
    | 'L' == c && '#' `notElem` cs                 = go xs ('#':acc)
    | '#' == c && length (filter (== '#') cs) >= 4 = go xs ('L':acc)
    | otherwise                                    = go xs (c:acc)

-- Actual part one
generateNewMatrix l = let (rows, _) = getColsRows l
                          str       = (generateStrByPosVals . calculatePosVals) l
                          in split rows rows str [] where
    split rows n []     acc = [acc]
    split rows n (c:cs) acc
      | n == 0    = (acc) : split rows rows (c:cs) []
      | otherwise = split rows (n - 1) cs (acc ++ [c])

goFind n infiniteCalcs = do
    putStrLn $ join ["calculating ", show n]
    if (infiniteCalcs !! n) == (infiniteCalcs !! (n + 2))
    then return $ infiniteCalcs !! n
    else goFind (n+1) infiniteCalcs

main = do
        handle <- openFile "input.txt" ReadMode
        contents <- hGetContents handle
        let entries = lines contents
        let infiniteCalcs = iterate generateNewMatrix entries
        foundList     <- goFind 0 infiniteCalcs
        print $ length $ filter (== '#') $ join foundList
        hClose handle   
