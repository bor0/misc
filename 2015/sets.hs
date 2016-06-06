import Data.List (nub)

set = [1, 2, 3]

idset [] = []
idset (x:xs) = nub $ (x, x) : idset xs

cartessian set = nub [(x, y) | x <- set, y <- set]

inverse [] = []
inverse ((a, b) : xs) = nub $ (b, a) : inverse xs

dom [] = []
dom ((a, b) : xs) = nub $ a : dom xs

ran [] = []
ran ((a, b) : xs) = nub $ b : ran xs

combineset set1 set2 = nub [(x, z) | (x, y) <- set1, (y, z) <- set2]

subset [] y = True
subset (x:xs) y = x `elem` y && subset xs y
