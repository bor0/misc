-- Verbose
data MergeV : List Nat -> List Nat -> List Nat -> Type where
  MergeVNilL : MergeV [] ys ys
  MergeVNilR : MergeV xs [] xs
  MergeVRecLT : MergeV xs ys zs -> LT x y -> MergeV (x::xs) ys (x::zs)
  MergeVRecGTE : MergeV xs ys zs -> GTE x y -> MergeV xs (y::ys) (y::zs)

exampleProof : MergeV [1, 3, 5] [2, 3, 4] [1, 2, 3, 3, 4, 5]
exampleProof =
  let lte4_5 = LTESucc $ LTESucc $ LTESucc $ LTESucc (LTEZero {right=1})
      lt1_2 = LTESucc $ LTESucc (LTEZero {right=0})
      gte3_2 = LTESucc $ LTESucc (LTEZero {right=1})
      lte4_5 = LTESucc $ LTESucc $ LTESucc $ LTESucc (LTEZero {right=1})
      lte3_4 = LTESucc $ LTESucc $ LTESucc (LTEZero {right=1})
  in MergeVRecLT (MergeVRecGTE (MergeVRecLT (MergeVRecGTE (MergeVRecGTE MergeVNilR lte4_5) lte3_4) lte4_5) gte3_2) lt1_2

data Merge : List Nat -> List Nat -> List Nat -> Type where
  MergeNilL : Merge [] ys ys
  MergeNilR : Merge xs [] xs
  MergeRecLT : Merge xs ys zs -> {auto prf:LT x y} -> Merge (x::xs) ys (x::zs)
  MergeRecGTE : Merge xs ys zs -> {auto prf:GTE x y} -> Merge xs (y::ys) (y::zs)

exampleProof' : Merge [1, 3, 5] [2, 3, 4] [1, 2, 3, 3, 4, 5]
exampleProof' = MergeRecLT (MergeRecGTE (MergeRecLT (MergeRecGTE (MergeRecGTE MergeNilR {x=5}) {x=3}) {y=4}) {x=3}) {y=2}
