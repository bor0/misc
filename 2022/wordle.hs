import Data.Char (toUpper)

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
      words'''        = [ word | all (\c -> (c `notElem` exists) || (c `elem` word)) dark, word <- words'' ]
  in words'''
