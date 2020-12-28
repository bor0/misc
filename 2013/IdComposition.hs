data A = A Int deriving (Show)
data B = B Int deriving (Show)

idA :: A -> A
idA x = x

idB :: B -> B
idB x = x

g :: A -> B
g (A x) = (B x

--g.idA = idB.g = g