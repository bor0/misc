data Expr = Number Int |
         Add Expr Expr |
         Mul Expr Expr |
         Sub Expr Expr |
         Div Expr Expr deriving Show

calcExpr expr = Number $ go expr
    where
    go (Number x) = x
    go (Add x y) = (go x) + (go y)
    go (Mul x y) = (go x) * (go y)
    go (Sub x y) = (go x) - (go y)
    go (Div x y) = (go x) `div` (go y)
