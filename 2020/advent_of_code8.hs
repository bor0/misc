import System.IO  
import Control.Monad

import qualified Data.Map as Map
import Data.List.Utils

data Instruction = Nop | Acc | Jmp deriving (Show)
data Command = I Instruction Int deriving (Show)
type Context = Map.Map String Int

getEmptyCtx :: Context
getEmptyCtx = Map.fromList [ ("acc", 0), ("IP", 0) ]

incIP :: Int -> Context -> Context
incIP n ctx = let ip = ctx Map.! "IP" in Map.insert "IP" (ip + n) ctx

eval :: Context -> Command -> Context
eval ctx (I Nop n) = incIP 1 ctx
eval ctx (I Acc n) = let acc = ctx Map.! "acc"
                     in Map.insert "acc" (acc + n) $ incIP 1 ctx
eval ctx (I Jmp n) = incIP n ctx

-- Left when it does not terminate, Right when it does. Additionally, prevIPs will be displayed
-- to show the last line before the looping command, this is used for part two.
-- The task defined terminating programs in such a way (command being executed more than once)
-- that this solution is applicable. In general, it's not a good definition for what a terminating program is.
evalAll :: [Command] -> Either (Context, [Int]) (Context, [Int])
evalAll cmds = go cmds getEmptyCtx [] where
  go cs ctx prevIPs = let ip = ctx Map.! "IP" in go' ip where
     go' ip
         | ip >= length cs   = Right (ctx, prevIPs)
         | ip `elem` prevIPs = Left (ctx, prevIPs)
         | otherwise         = let newctx = eval ctx (cs !! ip) in
                                   go cs newctx (ip:prevIPs)

main = do
        let list = []
        handle <- openFile "input.txt" ReadMode
        contents <- hGetContents handle
        let entries = map parseLine $ lines contents
        print $ evalAll entries
        hClose handle   

parseLine :: String -> Command
parseLine s = let [cmd, number] = split " " s in go cmd number where
  go "jmp" number   = I Jmp $ readNumber number
  go "acc" number   = I Acc $ readNumber number
  go "nop" _        = I Nop 0
  readNumber ('+':n) = read n
  readNumber number  = read number
