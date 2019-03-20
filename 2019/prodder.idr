total ProdderType : Num a => (numargs : Nat) -> Type
ProdderType {a} Z     = a
ProdderType {a} (S k) = Pair a (ProdderType k)

-- Variable length prodder, on any type of Num.
total prodder : Num a => (numargs : Nat) -> (acc : a) -> ProdderType numargs
prodder Z     acc = acc
prodder (S k) acc = MkPair acc (prodder k acc)

-- Idris> prodder 1 5
-- (5, 5) : (Integer, Integer)
-- Idris> prodder 2 5
-- (5, 5, 5) : (Integer, Integer, Integer)
-- Idris> prodder 3 5
-- (5, 5, 5, 5) : (Integer, Integer, Integer, Integer)
-- Idris> prodder 4 5
-- (5, 5, 5, 5, 5) : (Integer, Integer, Integer, Integer, Integer)
-- Idris> prodder 5 5
-- (5, 5, 5, 5, 5, 5) : (Integer, Integer, Integer, Integer, Integer, Integer)
