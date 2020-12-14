import System.IO  
import Control.Monad

data Instruction = North Int | East Int | South Int | West Int | TurnLeft Int | TurnRight Int | Forward Int

type Coordinates = (Int, Int, Int, Int)

-- Functions to rotate coordinates
rotateRight :: Coordinates -> Int -> Coordinates
rotateRight wp@(n,e,s,w) cnt = if 0 == cnt then wp else rotateRight (w,n,e,s) (cnt-1)

rotateLeft :: Coordinates -> Int -> Coordinates
rotateLeft  wp@(n,e,s,w) cnt = if 0 == cnt then wp else rotateLeft (e,s,w,n) (cnt-1)

-- Part one
calcManhattanDistanceOne :: [Instruction] -> Int
calcManhattanDistanceOne is = go is (0,0,0,0) (0,1,0,0) where
  go []                 (n,e,s,w) _               = abs (n - s) + abs (e - w)
  go ((North a):xs)     (n,e,s,w) d               = go xs (n+a,e,s,w) d
  go ((East a):xs)      (n,e,s,w) d               = go xs (n,e+a,s,w) d
  go ((South a):xs)     (n,e,s,w) d               = go xs (n,e,s+a,w) d
  go ((West a):xs)      (n,e,s,w) d               = go xs (n,e,s,w+a) d
  go ((TurnLeft a):xs)  dirs      d               = go xs dirs $ rotateLeft d (a `div` 90)
  go ((TurnRight a):xs) dirs      d               = go xs dirs $ rotateRight d (a `div` 90)
  go ((Forward a):xs)   (n,e,s,w) d@(n',e',s',w') = go xs (n+n'*a, e+e'*a, s+s'*a, w+w'*a) d

-- Part two
calcManhattanDistanceTwo :: [Instruction] -> Int
calcManhattanDistanceTwo is = go is (0,0,0,0) (1,10,0,0) where
  go []                 (n,e,s,w)     (n',e',s',w')    = abs (n - s) + abs (e - w)
  go ((North a):xs)     loc@(n,e,s,w) (n',e',s',w')    = go xs loc (n'+a,e',s',w')
  go ((East a):xs)      loc@(n,e,s,w) (n',e',s',w')    = go xs loc (n',e'+a,s',w')
  go ((South a):xs)     loc@(n,e,s,w) (n',e',s',w')    = go xs loc (n',e',s'+a,w')
  go ((West a):xs)      loc@(n,e,s,w) (n',e',s',w')    = go xs loc (n',e',s',w'+a)
  go ((TurnLeft a):xs)  loc           wp               = go xs loc $ rotateLeft wp (a `div` 90)
  go ((TurnRight a):xs) loc           wp               = go xs loc $ rotateRight wp (a `div` 90)
  go ((Forward a):xs)   (n,e,s,w)     wp@(n',e',s',w') = go xs (n+n'*a, e+e'*a, s+s'*a, w+w'*a) wp

{- Refactored, after I noticed very close similarities between p1 and p2. -}

-- A function to move the ship. The first argument is whether the movement is for the waypoint or the ship.
moveShip :: Bool -> Instruction -> (Coordinates, Coordinates) -> (Coordinates, Coordinates)
moveShip d (North a)     (loc@(n,e,s,w), wp@(n',e',s',w')) = if d then ((n+a,e,s,w), wp) else (loc, (n'+a,e',s',w'))
moveShip d (East a)      (loc@(n,e,s,w), wp@(n',e',s',w')) = if d then ((n,e+a,s,w), wp) else (loc, (n',e'+a,s',w'))
moveShip d (South a)     (loc@(n,e,s,w), wp@(n',e',s',w')) = if d then ((n,e,s+a,w), wp) else (loc, (n',e',s'+a,w'))
moveShip d (West a)      (loc@(n,e,s,w), wp@(n',e',s',w')) = if d then ((n,e,s,w+a), wp) else (loc, (n',e',s',w'+a))
moveShip _ (TurnLeft a)  (loc,       wp)                   = (loc, rotateLeft wp (a `div` 90))
moveShip _ (TurnRight a) (loc,       wp)                   = (loc, rotateRight wp (a `div` 90))
moveShip _ (Forward a)   ((n,e,s,w), wp@(n',e',s',w'))     = ((n+n'*a, e+e'*a, s+s'*a, w+w'*a), wp)

-- Part one
calcManhattanDistanceOne' :: [Instruction] -> Int
calcManhattanDistanceOne' is = let ((n,e,s,w), _) = foldr (moveShip True) ((0,0,0,0), (0,1,0,0)) is
                               in abs (n - s) + abs (e - w)

-- Part two
calcManhattanDistanceTwo' :: [Instruction] -> Int
calcManhattanDistanceTwo' is = let ((n,e,s,w),_) = foldl (flip $ moveShip False) ((0,0,0,0), (1,10,0,0)) is
                               in abs (n - s) + abs (e - w)

main = do
  handle <- openFile "input.txt" ReadMode
  contents <- hGetContents handle
  let entries = map parseLine $ lines contents
  print $ calcManhattanDistanceOne entries
  print $ calcManhattanDistanceOne' entries
  print $ calcManhattanDistanceTwo entries
  print $ calcManhattanDistanceTwo' entries
  hClose handle   

parseLine :: String -> Instruction
parseLine s = go s where
  go ('N':number) = North $ readNumber number
  go ('E':number) = East $ readNumber number
  go ('S':number) = South $ readNumber number
  go ('W':number) = West $ readNumber number
  go ('L':number) = TurnLeft $ readNumber number
  go ('R':number) = TurnRight $ readNumber number
  go ('F':number) = Forward $ readNumber number
  readNumber number  = read number
