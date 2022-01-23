-- -- Type level
-- data Append : List a -> List a -> List a -> Type where
--   AppendNil : (ys : List a) -> Append [] ys ys
--   AppendRec : (x : a) -> (xs : List a) -> (ys : List a) -> (zs : List a) -> (prf : Append xs ys zs) -> Append (x :: xs) ys (x :: zs)
--
-- -- Proof that [1] ++ [2] == [1, 2]
-- appendEg1 : Append [1] [2] [1, 2]
-- appendEg1 = AppendRec 1 [] [2] [2] (AppendNil [2])

data Append : List a -> List a -> List a -> Type where
  AppendNil : Append [] ys ys
  AppendRec : Append xs ys zs -> Append (x :: xs) ys (x :: zs)

appendEg1 : Append [1] [2] [1, 2]
appendEg1 = AppendRec AppendNil

-- Value level
append : List a -> List a -> List a
append []     ys = ys
append (x::xs) ys = x :: append xs ys

-- Proof that [1] ++ [2] == [1, 2]
appendEg2 : append [1] [2] = [1, 2]
appendEg2 = Refl
