getN (x, y, z) | x == min x (min y z) = (smooth (x + 2, y, z), x)
getN (x, y, z) | y == min x (min y z) = (smooth (x, y + 3, z), y)
getN (x, y, z) | z == min x (min y z) = (smooth (x, y, z + 5), z)

smooth (x, y, z) | x == y = (x, y + 3, z)
smooth (x, y, z) | y == z = (x, y, z + 5)
smooth (x, y, z) | x == z = (x, y, z + 5)
smooth x = x

getUglyNumber' 0 = 1
getUglyNumber' n = go (2, 3, 5) 0
  where
  go (x, y, z) k | k == n - 1 = snd $ getN (x, y, z)
  go (x, y, z) k = go (fst $ getN (x, y, z)) (k + 1)
