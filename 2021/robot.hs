type Coordinate = (Int, Int)
data Command = GoUp | GoDown | GoLeft | GoRight | Drop deriving (Show)

-- Get commands from coordinate A to coordinate B
getCommandsForPath :: Coordinate -> Coordinate -> [Command]
getCommandsForPath from@(x1, y1) to@(x2, y2)
  | x1 > x2   = GoLeft  : getCommandsForPath (x1 - 1, y1) to
  | y1 < y2   = GoDown  : getCommandsForPath (x1, y1 + 1) to
  | y1 > y2   = GoUp    : getCommandsForPath (x1, y1 - 1) to
  | x1 < x2   = GoRight : getCommandsForPath (x1 + 1, y1) to
  | otherwise = [Drop] -- coordinates are equal

-- Manually
getCommands :: [Coordinate] -> [Command]
getCommands coords = go (0, 0) coords
  where
  go (x1, y1) [] = []
  go from@(x1, y1) (to@(x2, y2):coords) = getCommandsForPath from to ++ go (x2, y2) coords

-- As a fold
getCommands' :: [Coordinate] -> [Command]
getCommands' coords = snd $ foldl go ((0, 0), []) coords
  where
  go (from, acc) to = (to, acc ++ getCommandsForPath from to)
