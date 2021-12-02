import Data.String

data Command = Forward Int | Down Int | Up Int

Show Command where
  show (Forward x) = "Forward " ++ show x
  show (Down x) = "Down " ++ show x
  show (Up x) = "Up " ++ show x

parseLine : String -> Maybe Command
parseLine s = go (split (== ' ') s) where
  go ["forward", number] = parseInteger number >>= pure . Forward
  go ["down", number] = parseInteger number >>= pure . Down
  go ["up", number] = parseInteger number >>= pure . Up

calculate : List (Maybe Command) -> (Int, Int, Int) -> Int
calculate ((Just (Forward x)::xs)) (aim, horizontal, depth) = calculate xs (aim, horizontal + x, depth + aim*x)
calculate ((Just (Down x)::xs)) (aim, horizontal, depth) = calculate xs (aim + x, horizontal, depth)
calculate ((Just (Up x)::xs)) (aim, horizontal, depth) = calculate xs (aim - x, horizontal, depth)
calculate (_::xs) acc = calculate xs acc
calculate [] (_, horizontal, depth) = horizontal * depth

main : IO ()
main = do file <- readFile "input"
          case file of
               Right content => printLn $ calculate (map parseLine (lines content)) (0, 0, 0)
               Left err => printLn err
