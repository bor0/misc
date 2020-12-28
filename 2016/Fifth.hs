import Data.List (inits, nub)

data Expr =
    A Expr Expr |
    S Expr Expr |
    C Expr Expr |
    I Int deriving Show

parse :: Expr -> Int
parse (A a b) = parse a + parse b
parse (S a b) = parse a - parse b
parse (C a b) = parse a * 10 + parse b
parse (I a) = a

listToC x = foldl C (head x) (tail x)

f :: Expr -> [String] -> [Expr] -> [(Expr, [String])]
f s ops xs@(_:_) = foldr foldingFunction [] $ calcInits xs
    where
    foldingFunction (a, b) l = f (A s b) (calculated "+" b) a
        ++ f (S s b) (calculated "-" b) a
        ++ l
    calculated op b = (op ++ show (parse b)) : ops
f s ops _        = [(s, ops)]

calcInits :: [Expr] -> [([Expr], Expr)]
calcInits x = go 1 (tail $ inits x)
    where
    go n xs@(x':xs') = (drop n x, listToC x') : go (n + 1) xs'
    go _ []     = []

main = do
    let l = f (I 0) [] (map I [1..9])
    let l' = filter (\x -> parse (fst x) == 100) l
    mapM_ (\(x, y) -> print $ concat $ reverse y) l'   
