module Assembler where

import qualified Data.Map as M
import Text.Printf (printf)

data Command =
  Cls
  | Ret
  | Label String
  | JmpLabel String
  | JmpAddr Integer
  deriving (Show)

type Program = [Command]

-- | Return a map of label and address
getLabels :: Program -> M.Map String Integer
getLabels = go 0x200
  where
  go _ [] = M.empty
  go i ((Label x):ps) = M.insert x i (go (i+2) ps)
  go i (_:ps) = go (i+2) ps

-- | Check if an assembly code is valid: numbers are in range, labels are set correctly, etc.
check :: Program -> Either String Program
check p@((Label x):_) | x == "start" = go p p (getLabels p)
  where
  go prog (p:ps) labels = checkSingle p (M.keys labels) >>= \_ -> go prog ps labels
  go prog [] _ = Right prog
  checkSingle (JmpLabel x) labels | x `notElem` labels = Left "Label does not exist"
  checkSingle (JmpAddr x) _ | x < 0 || x > 4095 = Left "Address out of bounds"
  checkSingle _ _ = Right ()
check _ = Left "No 'start' label"

assemble :: Program -> String
assemble p = go p
  where
  labels = getLabels p
  go (p:ps) = assembleSingle p ++ go ps
  go _ = ""
  assembleSingle Cls = "00E0"
  assembleSingle Ret = "00EE"
  assembleSingle (Label _) = "" -- labels have no corresponding machine code, they're part of the meta language
  assembleSingle (JmpLabel x) = "1" ++ printf "%03x" (labels M.! x)
  assembleSingle (JmpAddr x) = "1" ++ printf "%03x" x

checkAssemble :: Program -> Either String String
checkAssemble p = check p >>= return . assemble

egProgram :: Program
egProgram = [Label "start", Cls, JmpLabel "start"]
