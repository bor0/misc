import Data.List (isInfixOf)
import Data.List.Split (splitOn)
import qualified Data.Text as T

removeComments :: String -> String
removeComments code = unlines $ go (lines code) False []
    where
    breakOn pat src = let (x, y) = T.breakOn (T.pack pat) (T.pack src) in (T.unpack x, T.unpack y)
    go (x:xs) block_comment str
      | block_comment =
        if "*/" `isInfixOf` x then
            go xs False str ++ [tail.tail $ snd $ breakOn "*/" x]
        else
            go xs block_comment (str ++ [x])
      | "//" `isInfixOf` x = go xs block_comment str ++ [fst (breakOn "//" x)]
      | "/*" `isInfixOf` x = go (snd (breakOn "/*" x) : xs) True str ++ [fst (breakOn "/*" x)]
      | otherwise = go xs block_comment (str ++ [x])
    go [] _ str = str

main = getContents >>= putStr . removeComments
