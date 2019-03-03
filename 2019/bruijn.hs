type Name  = String
type Index = (String, Int)

data Expr
  = Var Name
  | App Expr Expr
  | Lam Name Expr
  deriving (Eq, Show)

pprint :: Expr -> String
pprint (Var n)    = n
pprint (Lam n e)  = "λ" ++ n ++ "." ++ pprint e
pprint (App e e') = maybeEnclose e ++ " " ++ maybeEnclose e'

maybeEnclose :: Expr -> String
maybeEnclose (Var n) = n
maybeEnclose x       = "(" ++ pprint x ++ ")"

pprint' x = putStrLn $ pprint x

findByFst :: [Index] -> String -> Int
findByFst ((x, y) : xs) x' = if x' == x then y else findByFst xs x'
findByFst _ _              = error "var not found"

bruijn :: Expr -> Expr
bruijn e = go [] e where
    go m (Lam x e)  = Lam "" $ let m' = map (\(x, y) -> (x, y + 1)) m in go ((x, 0) : m') e
    go m (App e e') = App (go m e) (go m e')
    go m (Var x)    = Var $ show $ findByFst m x

-- *Main> let expr = (Lam "s" (Lam "z" (Var "z"))) in pprint' expr >> pprint' (bruijn expr)
-- λs.λz.z
-- λ.λ.0
-- *Main> let expr = (Lam "s" (Lam "z" (App (Var "s") (App (Var "s") (Var "z"))))) in pprint' expr >> pprint' (bruijn expr)
-- λs.λz.s (s z)
-- λ.λ.1 (1 0)
-- *Main> let expr = (Lam "m" (Lam "n" (Lam "s" (Lam "z" (App (App (Var "m") (Var "s")) (App (App (Var "n") (Var "z")) (Var "s"))))))) in pprint' expr >> pprint' (bruijn expr)
-- λm.λn.λs.λz.(m s) ((n z) s)
-- λ.λ.λ.λ.(3 1) ((2 0) 1)
