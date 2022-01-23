-- Type level
data Append : List a -> List a -> List a -> Type where
  AppendNil : (ys : List a) -> Append [] ys ys
  AppendRec : (x : a) -> (xs : List a) -> (ys : List a) -> (zs : List a) -> Append (x :: xs) ys (x :: zs)

-- Proof that [1, 2] ++ [3, 4] == [1, 2, 3, 4]
appendEg1 : Append [1, 2] [3, 4] [1, 2, 3, 4]
appendEg1 = AppendRec 1 [2] [3, 4] [2, 3, 4] 

-- Value level
append : List a -> List a -> List a
append []     ys = ys
append (x::xs) ys = x :: append xs ys

-- Proof that [1, 2] ++ [3, 4] == [1, 2, 3, 4]
appendEg2 : append [1, 2] [3, 4] = [1, 2, 3, 4]
appendEg2 = Refl
