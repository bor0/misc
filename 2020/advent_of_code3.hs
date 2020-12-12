type Coordinate = (Int, Int)
type GridSize   = (Int, Int)

list :: [String]
list = []

getGridSize :: [String] -> GridSize
getGridSize list = (length $ head list, length list)

-- Part one
findCoordinates :: Coordinate -> GridSize -> [Coordinate]
findCoordinates (x, y) (width, height) = go (x, y) height where
  go _ 0               = []
  go (x, y) cnt        = (x `mod` width, y) : go (slopeModifier (x, y)) (cnt - 1)
  slopeModifier (x, y) = (x + 3, y + 1)

countTrees :: [String] -> Int
countTrees list =
  let coordinates  = findCoordinates (0, 0) $ getGridSize list
      landedCoords = map (\(x, y) -> list !! y !! x) coordinates
  in length $ filter (== '#') landedCoords

partOne :: Int
partOne = countTrees list

-- Part two has a more generalized findCoordinates
findCoordinates' :: Coordinate -> GridSize -> (Coordinate -> Coordinate) -> [Coordinate]
findCoordinates' (x, y) (width, height) slopeModifier = go (x, y) height where
  go (x, y) cnt
      | y > height = [] -- Need this additional check since we might have a slope modifier that increases height by >1
      | cnt == 0       = []
      | otherwise      = (x `mod` width, y) : go (slopeModifier (x, y)) (cnt - 1)

countTrees' :: [String] -> (Coordinate -> Coordinate) -> Int
countTrees' list slopeModifier =
  let coordinates  = findCoordinates' (0, 0) (getGridSize list) slopeModifier
      landedCoords = map (\(x, y) -> list !! y !! x) coordinates
  in length $ filter (== '#') landedCoords

slopeModifiers :: [Coordinate -> Coordinate]
slopeModifiers = [ \(x, y) -> (x + 1, y + 1),
            \(x, y) -> (x + 3, y + 1),
            \(x, y) -> (x + 5, y + 1),
            \(x, y) -> (x + 7, y + 1),
            \(x, y) -> (x + 1, y + 2) ]

partOne' :: Int
partOne' = countTrees' list ( \(x, y) -> (x + 3, y + 1) )

partTwo :: Int
partTwo  = product $ map (countTrees' list) slopeModifiers

-- Simpler findCoordinates
findCoordinates'' :: GridSize -> (Coordinate -> Coordinate) -> [Coordinate]
findCoordinates'' (width, height) slopeModifier =
  let slopeModifiedCoords = take height $ iterate slopeModifier (0, 0)
      flattenedXCoords    = map (\(x, y) -> (x `mod` width, y)) slopeModifiedCoords
  in filter (\(x, y) -> y <= height) flattenedXCoords -- make sure to include only valid y coords

countTrees'' :: [String] -> (Coordinate -> Coordinate) -> Int
countTrees'' list slopeModifier =
  let coordinates  = findCoordinates'' (getGridSize list) slopeModifier
      landedCoords = map (\(x, y) -> list !! y !! x) coordinates
  in length $ filter (== '#') landedCoords

partOne'' :: Int
partOne'' = countTrees'' list ( \(x, y) -> (x + 3, y + 1) )

partTwo' :: Int
partTwo'  = product $ map (countTrees'' list) slopeModifiers
