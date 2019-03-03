import System.IO
import Control.Monad
import Control.Concurrent

type Var = Int

data Tinydsl =
    Increase |
    Decrease |
    Set Var  |
    Multiply Var deriving (Show, Read)

eval :: Var -> Tinydsl -> Var
eval _ (Set x)      = x
eval x Increase     = x + 1
eval x Decrease     = x - 1
eval x (Multiply y) = x * y

readDsl :: String -> Tinydsl
readDsl = read

evalFile :: Var -> String -> IO Var
evalFile x f = do
    contents <- readFile f
    return $ eval x $ readDsl contents

main :: IO ()
main = do
    plugins <- readFile "plugins.config"
    result  <- foldM evalFile undefined (lines plugins)
    print result
    threadDelay 1000000 -- sleep for a second
    main
