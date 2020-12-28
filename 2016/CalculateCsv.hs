module CalculateCsv where
import System.IO
import Data.List (groupBy, sortBy, sort)
import Data.List.Split (splitOn)
import System.Environment (getArgs)
import Control.Monad (unless)

type Caller = String
type Callee = String
data Call = Caller :-> Callee deriving (Show)

callerCalleeGroup :: Call -> Call -> Bool
callerCalleeGroup (a :-> b) (c :-> d) = a == c && b == d

callerGroup :: Call -> Call -> Bool
callerGroup (a :-> _) (b :-> _)       = a == b

calculateGroupings :: [Call] -> [[[Call]]]
calculateGroupings x = map (groupBy callerCalleeGroup) $ groupBy callerGroup x

calculateForCaller :: [[Call]] -> [(Call, Int)]
calculateForCaller   = map (\x -> (head x, length x))

calculateCalls :: [Call] -> [(Call, Int)]
calculateCalls x     = sortBy (\(_, x) (_, y) -> compare y x) $ concatMap calculateForCaller $ calculateGroupings x

getCalls :: String -> [(Call, Int)]
getCalls f           =
    calculateCalls f''
    where
    f' = map (splitOn ",") $ sort $ lines f
    f'' = foldr (\[a, b] y -> (a :-> b) : y) [] f'

main = do
    x <- getArgs
    unless (null x) $ do
        f <- readFile $ head x
        mapM_ display $ getCalls f
    where
    display (caller :-> callee, n) = putStrLn $ "(" ++ show n ++ ") " ++ caller ++ " кон " ++ callee
