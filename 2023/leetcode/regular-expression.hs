data RegLit = RDot | RChr Char deriving (Show, Eq)

data RegExp =
  RELit RegLit
  | REStar RegLit
  deriving (Show, Eq)

matchRE :: String -> [RegExp] -> Bool
matchRE [] [] = True
matchRE (x:xs) ((RELit (RChr y)):ys) = x == y && matchRE xs ys
matchRE (x:xs) (RELit RDot:ys)       = matchRE xs ys
matchRE xs ((REStar (RChr x)):ys)    = or [ matchRE (drop i xs) ys | i <- [0..length $ takeWhile (== x) xs] ]
matchRE xs ((REStar RDot):ys)        = or [ matchRE (drop i xs) ys | i <- [0..length xs] ]
matchRE _ _ = False

stringToRE :: String -> [RegExp]
stringToRE [] = []
stringToRE ('.':'*':xs) = REStar RDot : stringToRE xs
stringToRE (x:'*':xs)   = REStar (RChr x) : stringToRE xs
stringToRE ('.':xs)     = RELit RDot : stringToRE xs
stringToRE (x:xs)       = RELit (RChr x) : stringToRE xs

match :: String -> String -> Bool
match x y = matchRE x (stringToRE y)

examplePairs = [
  ("abc", "abc"),
  ("abc", "a.c"),
  ("abc", ".*c"),
  ("abc", "a*bc"),
  ("", ".*"),
  ("abc", ""),
  ("", ""),
  ("abcd", "a.d"),
  ("a1b2c3", "a.b.c"),
  ("xy", ".."),
  ("aaab", "a*b"),
  ("ab", ".."),
  ("abcd", "a.*d"),
  ("aaaaaa", "aaa*"),
  ("xyz", "...*"),
  ("abc", "abc*"),
  ("abcde", "a.*e"),
  ("xyxxy", "x.*y.*x"),
  ("a.b.c", "a.b.c"),
  ("123*", "123*"),
  ("aab", "aab"),
  ("aaabbb", "ab"),
  ("abc", "ABC"),
  ("AbC", "aBc"),
  ("aaaabbbbcccc", "abc*"),
  ("aab", "c*a*b"),
  ("mississippi", "mis*is*ip*."),
  ("mississippi", "mis*is*p*."),
  ("aaa", "ab*a"),
  ("a", "ab*"),
  ("a", ".*..a*")
 ]

main = do
  mapM_ go examplePairs
  where
  go (s, p) = putStrLn $ s ++ ", " ++ p ++ " = " ++ (show $ match s p)
