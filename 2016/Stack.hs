{-# OPTIONS_GHC -XFlexibleContexts -XPackageImports #-}
import "mtl" Control.Monad.Trans (liftIO)
import qualified Data.Char as Char
import Text.Read (readMaybe)
import Control.Exception
import System.IO

data Command = Push Int | Pop | Reset | Save | Load deriving (Read, Show)
type Stack = ([Int], Maybe Int)

emptyStack = ([], Nothing)

capitalize :: String -> String
capitalize (x:xs) = Char.toUpper x : map Char.toLower xs
capitalize [] = []

run :: Command -> Stack -> Stack
run (Push x) (l, e)   = (x : l, e)
run Pop (l, e)        = case l of
    (x:xs) -> (xs, Just x)
    _      -> emptyStack
run Reset _           = emptyStack
run Save s            = s
run Load s            = s

runSave :: Stack -> IO ()
runSave s = do
    writeFile "stack.st" $ show s
    putStrLn "Saved data to \"stack.st\"."

runLoad :: IO Stack
runLoad = do
    s' <- readFile "stack.st"
    putStrLn "Loaded data from \"stack.st\"."
    return $ read s'

stackLoop s = do
    putStr "Stack> "
    hFlush stdout
    x <- getLine
    case readMaybe (capitalize x) of
        Just c -> case c of
            Save        -> runSave s >> (liftIO $ stackLoop s)
            Load        -> runLoad >>= (liftIO . stackLoop)
            otherwise   -> do
                let res = run c s
                print res
                stackLoop res
        Nothing -> stackLoop s

main = do
    putStrLn "Write \"push <int>\" to insert, \"pop\" to retrieve, \"reset\" to reset, \"save\" to save, \"load\" to load."
    stackLoop emptyStack
