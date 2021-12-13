import System.IO  
import Control.Monad

import Text.Regex
import Data.Maybe

import Data.List.Utils

isFieldValid :: String -> String -> Bool
isFieldValid "byr" value = let valueNum = read value :: Int in 1920 <= valueNum && valueNum <= 2002 -- Could use readMaybe instead, to be safer
isFieldValid "iyr" value = let valueNum = read value :: Int in 2010 <= valueNum && valueNum <= 2020
isFieldValid "eyr" value = let valueNum = read value :: Int in 2020 <= valueNum && valueNum <= 2030
isFieldValid "hgt" value =
    let regex = mkRegex "(^([0-9]+)(cm|in)$)" in isValidHgt $ matchRegex regex value where
        isValidHgt (Just [_, value, "cm"]) = let valueNum = read value :: Int in 150 <= valueNum && valueNum <= 193
        isValidHgt (Just [_, value, "in"]) = let valueNum = read value :: Int in 59 <= valueNum && valueNum <= 76
        isValidHgt _                   = False
isFieldValid "hcl" value = let regex = mkRegex "^#[0-9a-f]{6}$" in isJust $ matchRegex regex value
isFieldValid "ecl" value = let validValues = [ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" ] in value `elem` validValues
isFieldValid "pid" value = let regex = mkRegex "^[0-9]{9}$" in isJust $ matchRegex regex value
isFieldValid _ _         = False

main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let entries = parseContents contents
  print $ length $ filter (== True) $ map parseAndCheckEntry entries
  print $ length $ filter (== True) $ map parseAndCheckEntryTwo entries
  hClose handle   

parseContents contents = let
  entries          = split "\n\n" contents
  newlinesStripped = map (replace "\n" " ") entries
  fieldsSplitted   = map (split " ") newlinesStripped
  fieldsFiltered   = map (filter (/= "")) fieldsSplitted
  fields           = map (map $ split ":") fieldsFiltered
  in fields

parseAndCheckEntry entry    = 8 == length entry || ( 7 == length entry && "cid" `notElem` map head entry )
parseAndCheckEntryTwo entry = parseAndCheckEntry $ filter (\y -> isFieldValid (head y) (y !! 1)) entry
