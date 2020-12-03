type Coordinate = (Int, Int)
type GridSize   = (Int, Int)

list :: [String]
list = []

-- Part one
findCoordinates :: Coordinate -> GridSize -> [Coordinate]
findCoordinates (x, y) (gridWidth, gridHeight) = go (x, y) gridHeight where
    go _ 0               = []
    go (x, y) cnt        = (x `mod` gridWidth, y) : go (slopeModifier (x, y)) (cnt - 1)
    slopeModifier (x, y) = (x + 3, y + 1)

countTrees :: [String] -> Int
countTrees list = let gridWidth    = length $ head list
                      gridHeight   = length list
                      coordinates  = findCoordinates (0, 0) (gridWidth, gridHeight)
                      landedCoords = map (\(x, y) -> list !! y !! x) coordinates
                  in length $ filter (== '#') landedCoords

partOne :: Int
partOne = countTrees list

-- Part two has a more generalized findCoordinates
findCoordinates' :: Coordinate -> GridSize -> (Coordinate -> Coordinate) -> [Coordinate]
findCoordinates' (x, y) (gridWidth, gridHeight) slopeModifier = go (x, y) gridHeight where
    go (x, y) cnt
        | y > gridHeight = [] -- Need this additional check since we might have a slope modifier that increases height by >1
        | cnt == 0       = []
        | otherwise      = (x `mod` gridWidth, y) : go (slopeModifier (x, y)) (cnt - 1)

countTrees' :: [String] -> (Coordinate -> Coordinate) -> Int
countTrees' list slopeModifier = let gridWidth    = length $ head list
                                     gridHeight   = length list
                                     coordinates  = findCoordinates' (0, 0) (gridWidth, gridHeight) slopeModifier
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
findCoordinates'' :: Coordinate -> GridSize -> (Coordinate -> Coordinate) -> [Coordinate]
findCoordinates'' (x, y) (gridWidth, gridHeight) slopeModifier = let slopeModifiedCoords = take gridHeight $ iterate slopeModifier (x, y)
                                                                     flattenedXCoords    = map (\(x, y) -> (x `mod` gridWidth, y)) slopeModifiedCoords
                                                                     filteredYCoords     = filter (\(x, y) -> y <= gridHeight) flattenedXCoords
                                                                 in filteredYCoords

countTrees'' :: [String] -> (Coordinate -> Coordinate) -> Int
countTrees'' list slopeModifier = let gridWidth   = length $ head list
                                      gridHeight   = length list
                                      coordinates  = findCoordinates'' (0, 0) (gridWidth, gridHeight) slopeModifier
                                      landedCoords = map (\(x, y) -> list !! y !! x) coordinates
                                  in length $ filter (== '#') landedCoords

partOne'' :: Int
partOne'' = countTrees'' list ( \(x, y) -> (x + 3, y + 1) )

partTwo' :: Int
partTwo'  = product $ map (countTrees'' list) slopeModifiers
