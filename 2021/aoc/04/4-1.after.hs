-- Parsing
intToNat 0 = O
intToNat x = S (intToNat (x Prelude.- 1))
listConversion [] = Nil
listConversion (x:xs) = Cons x (listConversion xs)
natToInt O = 0
natToInt (S n) = 1 Prelude.+ natToInt n

parseTable table = let
  newlines = splitOn "\n" table
  joined   = Prelude.unwords newlines
  spaces   = splitOn " " joined
  spaces'  = Prelude.filter (Prelude./= "") spaces
  joined'  = Prelude.map (\x -> intToNat (Prelude.read x :: Prelude.Int)) spaces'
  joined'' = Prelude.map Unmarked joined'
  in joined''

parseContents contents = let
  entries  = splitOn "\n\n" contents
  numbers  = Prelude.head entries
  numbers' = listConversion (Prelude.map (\x -> intToNat (Prelude.read x :: Prelude.Int)) (splitOn "," numbers))
  tables   = Prelude.tail entries
  tables'  = listConversion (Prelude.map (\x -> listConversion (parseTable x)) tables)
  in (numbers', tables')

-- Main
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let (numbers', tables') = parseContents contents
  print (natToInt (calculate tables' numbers'))
  hClose handle
