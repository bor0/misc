data StaticExpr =
    StaticExpr Int
    | Add StaticExpr StaticExpr
    | Sub StaticExpr StaticExpr deriving (Show)

staticEval :: StaticExpr -> Int
staticEval (Add e1 e2)    = staticEval e1 + staticEval e2
staticEval (Sub e1 e2)    = staticEval e1 - staticEval e2
staticEval (StaticExpr x) = x

-- vs

data Expr =
    Expr Int
    | EExpr [Operator]

data Operator = Operator
    { name :: String
    , with :: Int -> Int
    }

eval :: Expr -> Int
eval (EExpr ((Operator _ with):xs)) = with $ eval $ EExpr xs
eval (EExpr [])      = 0
eval (Expr x) = x

-- module1.hs
o1 = Operator "add1" (\num -> num + 1)

-- module2.hs
o2 = Operator "sub1" (\num -> num - 1)

-- runner.hs
main = do
    print $ staticEval (Sub (Add (StaticExpr 1) (StaticExpr 1)) (StaticExpr 1))
    print $ eval $ EExpr [o1, o1, o2]
