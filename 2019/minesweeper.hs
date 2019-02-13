data MsVal =
    Empty |
    Bomb  |
    BombCount Int deriving (Show, Eq)

type MsGrid = [[MsVal]]
type GridSize = (Int, Int)
type Cell = (Int, Int)

-- | Read value from a cell in a given grid
readCell :: Cell -> MsGrid -> MsVal
readCell (x, y) grid = grid !! x !! y

-- | Write value to a cell in a given grid
updateCell :: Cell -> MsVal -> MsGrid -> MsGrid
updateCell (x, y) value grid =
    take x grid ++
    [take y (grid !! x) ++ [value] ++ drop (y + 1) (grid !! x)] ++
    drop (x + 1) grid

-- | Determine grid size (width, height)
gridSize :: MsGrid -> GridSize
gridSize grid = (length grid, length $ head grid)

-- | Get coordinates to check for bombs in a given cell
getBoxCoords :: Cell -> MsGrid -> [Cell]
getBoxCoords (x, y) grid =
    let coords = [(x+dx, y+dy) | dx <- [-1, 0, 1], dy <- [-1, 0, 1]]
    in
    -- Filter to only use valid coordinates
    filter (\coord -> inBounds coord grid && coord /= (x, y)) coords
    where
    -- | Bounds checker
    inBounds :: Cell -> MsGrid -> Bool
    inBounds (x, y) grid =
        let (w, h) = gridSize grid
        in
            ((-1) < x) && 
            (x < w) && 
            ((-1) < y) && 
            (y < h)

-- | Update grid to reflect proper bomb counts (will avoid updating bombs)
updateBombCounts :: MsGrid -> MsGrid
updateBombCounts grid =
    let size      = gridSize grid
        -- Calculate all coordinates for the given grid
        coords    = [(x, y) | x <- [0..fst size-1], y <- [0..snd size-1]]
        -- Calculate all possible box coordinates for each coordinate
        boxcoords = map (\coord -> (coord, getBoxCoords coord grid)) coords
        -- Get the values for each box coordinate
        boxvalues = map (\(coord, coords) -> (coord, map (`readCell` grid) coords)) boxcoords
        -- Count the bombs
        bombcnt   = map (\(coord, values) -> (coord, length $ filter (== Bomb) values)) boxvalues
        -- Filter non-bomb coordinates and non-zero bombs
        bombcnt'  = filter (\(coord, bombs) -> readCell coord grid /= Bomb && bombs /= 0) bombcnt
    in
        go bombcnt' grid
    where
        go []                  grid = grid
        go ((coord, bombs):xs) grid = go xs $ updateCell coord (BombCount bombs) grid

-- | Insert a bomb into a given position
insertBomb :: Cell -> MsGrid -> MsGrid
insertBomb (x, y) = updateCell (x, y) Bomb

-- | Initial empty grid
emptyGrid :: Cell -> MsGrid
emptyGrid (x, y) = replicate x $ replicate y Empty

-- | Generate a grid given a list of bomb positions and grid size
generateGrid :: [Cell] -> GridSize -> MsGrid
generateGrid bombs size = go bombs (emptyGrid size)
    where
    go [] grid     = updateBombCounts grid
    go (b:bs) grid = go bs (insertBomb b grid)

main :: IO ()
main = do
    let wootgrid = generateGrid [(0, 0), (5, 5), (9, 9)] (10, 10)
    mapM_ print wootgrid
