--stack runhaskell wordle.hs

import Control.DeepSeq (deepseq)
import Data.Char (toUpper)
import Data.List (nub)
import Data.List.Split (splitOn)
import System.Directory (doesFileExist)
import System.IO

findBest words = go (filter allCharsUnique words) 0 "" where
  allCharsUnique s = nub s == s
  countVowels s = length $ filter (`elem` "aeiou") s
  go (x:xs) n s = let cnt = countVowels x in if cnt >= n then go xs cnt x else go xs n s
  go [] _ s = s

updateWords words word dat =
  let processed       = zip3 word (map toUpper dat) [0..length dat]
      getProcessed x  = filter (\(c, d, i) -> d == x) processed
      -- Process green: the letter is in the word and in that particular position
      words'          = [ word | word <- words, all (\(c, d, i) -> word !! i == c) (getProcessed 'G') ]
      -- Process orange: the letter is in the word but not in that particular position
      words''         = [ word | word <- words', all (\(c, d, i) -> word !! i /= c && c `elem` word) (getProcessed 'O') ]
      exists          = [ c | (c, d, i) <- processed, d == 'G' || d == 'O' ]
      dark            = [ c | (c, d, i) <- getProcessed 'D' ]
      -- Process dark: Include only those whose letters are also found in `exists`
      words'''        = [ word | word <- words'', all (\c -> (c `elem` exists) || (c `notElem` word)) dark  ]
  in words'''

main = do
  fileExists <- doesFileExist "sgb-words.txt"
  if fileExists then do
    hSetBuffering stdin LineBuffering -- to be able to use backspace
    handle <- openFile "sgb-words.txt" ReadMode
    contents <- hGetContents handle
    let words = contents `deepseq` filter (/= "") $ splitOn "\n" contents
    contents `deepseq` hClose handle -- force eval before closing
    runLoop (findBest words) words
  else putStrLn "Google for 'sgb-words.txt' and download it in the same cwd as this program."

runLoop word words = do
  if length words == 1 then putStrLn $ "Solution: " ++ head words
  else if null words then putStrLn "No solution found."
  else do

  putStrLn $ "Enter the following word in Wordle: " ++ word
  putStr "Enter string value from Wordle (G=Green, O=Orange, D=Dark), or S to skip: "
  dat <- getLine

  let dat' = map toUpper dat
  let filteredWords = filter (/= word) words
  let calculatedWords = updateWords words word dat'

  if dat' == "S"
  then runLoop (head filteredWords) filteredWords
  else runLoop (head calculatedWords) calculatedWords
