import System.IO  
import Control.Monad

import qualified Data.Map as Map
import Data.List.Utils
import Data.List (nub)

type BagNumber = Integer
type BagName = String
type Bag = (BagNumber, BagName)

-- Part one
findOuterMostBagsContaining :: Map.Map BagName [Bag] -> BagName -> [BagName]
findOuterMostBagsContaining m = go where
  go bagname                   = let bags = bagsThatContainBag bagname in nub $ bags ++ concatMap go bags
  bagsThatContainBag bagname   = Map.keys $ Map.filter (filterFun bagname) m
  filterFun bagname bags       = bagname `elem` map snd bags

-- Part two
countBagContainment :: Map.Map BagName [Bag] -> BagName -> BagNumber
countBagContainment m = go where
  go bagname                    = let bags = bagsInBag bagname in foldr foldFun 0 bags
  bagsInBag bagname             = m Map.! bagname
  foldFun (number, bagname) acc = number + number * go bagname + acc

main = do
        let list = []
        handle <- openFile "input.txt" ReadMode
        contents <- hGetContents handle
        let entries = parseContents contents
        print $ length $ findOuterMostBagsContaining entries "shiny gold"
        print $ countBagContainment entries "shiny gold"
        hClose handle   

parseLine s = let [bag, bags]  = split " contain " s
                  bags'        = split ", " bags
                  bags''       = filter (/= "no other bags.") bags'
              in (getBagName bag, map (parseBags . getBagsName) bags'')
              where
  getBagName  s  = Data.List.Utils.join " " $ take 2 $ split " " s
  getBagsName s  = Data.List.Utils.join " " $ take 3 $ split " " s
  parseBags   bs = let [number, bagName, bagName''] = split " " bs
                   in (read number :: BagNumber, bagName ++ " " ++ bagName'')

parseContents contents = let
    entries       = filter (/= "") $ split "\n" contents
    parsedEntries = map parseLine entries
    entriesMap    = Map.fromList parsedEntries
    in entriesMap
