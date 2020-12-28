data Shape = Circle { cx :: Double, cy :: Double, radius :: Double } | Rectangle Double Double Double Double deriving Show

-- Shape - type constructor
-- Circle - data constructor
-- Rectangle - data constructor

-- Circle e funkcija, cx/cy/radius se funkcii
-- Rectangle e funkcija

-- :t Circle vrakja shape
-- :t Rectangle vrakja shape

data Point = Point { x :: Double, y :: Double } deriving Show
asdf = \(Point x _) -> 3
asdf' = \(Point{x = theX}) -> 3 * theX

asdfPM :: Point -> Integer
asdfPM (Point x _) = 3

asdfPM' :: Point -> Double
asdfPM' (Point{x = theX}) = 3 * theX
