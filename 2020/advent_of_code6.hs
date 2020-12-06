import System.IO  
import Control.Monad

import Data.List (nub, intersect, union)
import Data.List.Utils

-- Part one
countGroupAnswersAny :: [String] -> Int
countGroupAnswersAny l = length $ foldl1 union l

-- Part two
countGroupAnswersEvery :: [String] -> Int
countGroupAnswersEvery l = length $ foldl1 intersect l

main = do
        let list = []
        handle <- openFile "input.txt" ReadMode
        contents <- hGetContents handle
        let entries = parseContents contents
        print $ sum $ map countGroupAnswersAny entries
        print $ sum $ map countGroupAnswersEvery entries
        hClose handle   

parseContents contents = let
    entries  = split "\n\n" contents
    groups   = map (split "\n") entries
    filtered = map (filter (/= "")) groups 
    in filtered
