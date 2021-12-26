import Eval
import Expr
import State 

import Data.List.Split (splitOn)
import System.IO

main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let program = filter (/= "") $ splitOn "\n" contents
  print $ run program [9]
  let coolState = calcState program
  print coolState
  print $ runState (calcState program) [9]
  let coolState' = coolState { varW = optimize $ varW coolState, varX = optimize $ varX coolState, varY = optimize $ varY coolState, varZ = optimize $ varZ coolState  }
  print coolState'
  hClose handle
