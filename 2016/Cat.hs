-- I.
cat []     ys = ys
-- II.
cat (x:xs) ys = x : (cat xs ys)

{-
Prove: cat xs [] = cat [] xs
Proof:

Induction on xs:

Base case:

cat [] [] = cat [] [], which by definition is [] = [] which is true

Induction step:

Assume it holds for xs, i.e.:

cat xs [] = cat [] xs

Prove it holds for (x:xs), i.e.:

cat (x:xs) [] = cat [] (x:xs)

LHS: cat (x:xs) [] = by II = x : (cat xs []) = by IH = x : (cat [] xs) = by I = x : xs
RHS: cat [] (x:xs) = by I  = x : xs

-}
