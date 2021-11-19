import Data.List (minimumBy, delete)
import Data.Function (on)

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

-- Given a coordinate and a list of coordinates, find the nearest one
findNextPoint :: Coordinate -> [Coordinate] -> Coordinate
findNextPoint point coords = fst $ minimumBy (compare `on` snd) distances
  where
  distance (x1, y1) (x2, y2) = sqrt ((fromIntegral x2 - fromIntegral x1)^2 + (fromIntegral y2 - fromIntegral y1)^2)
  distances = map (\point' -> (point', distance point point')) coords

-- Sort all coordinates according to `findNextPoint`
sortCoordinates :: [Coordinate] -> [Coordinate]
sortCoordinates coords = tail $ go (0, 0) coords
  where
  go point []     = [point]
  go point coords =
    let newPoint = findNextPoint point coords
        in point : go newPoint (delete newPoint coords)

-- Same as getCommands', but more performant in some cases, and less performant in others.
-- let coords = [(0,3),(2,2)] in length (runRobot coords) > length (getCommands' coords)
-- let coords = [(0,3),(2,5)] in length (runRobot coords) < length (getCommands' coords)
runRobot :: [Coordinate] -> [Command]
runRobot = getCommands' . sortCoordinates

{-
> getCommands' [(3, 3), (2, 2)]
[GoDown,GoDown,GoDown,GoRight,GoRight,GoRight,Drop,GoLeft,GoUp,Drop]
> runRobot [(3, 3), (2, 2)]
[GoDown,GoDown,GoRight,GoRight,Drop,GoDown,GoRight,Drop]
-}
