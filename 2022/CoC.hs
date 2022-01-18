--https://gist.github.com/ChristopherKing42/d8c9fde0869ec5c8feae71714e069214
--Related paper: Henk: a typed intermediate language
data Expr = Star | Box | Var Int | Lam Int Expr Expr | Pi Int Expr Expr | App Expr Expr deriving (Show, Eq)

subst v e (Var v')       | v == v' = e
subst v e (Lam v' ta b ) | v == v' = Lam v' (subst v e ta)            b
subst v e (Lam v' ta b )           = Lam v' (subst v e ta) (subst v e b )
subst v e (Pi  v' ta tb) | v == v' = Pi  v' (subst v e ta)            tb
subst v e (Pi  v' ta tb)           = Pi  v' (subst v e ta) (subst v e tb)
subst v e (App f a     )           = App    (subst v e f ) (subst v e a )
subst v e e' = e'

free v e = e /= subst v (Var $ v + 1) e

normalize (Lam v ta b) = case normalize b of
    App vb (Var v') | v == v' && not (free v vb) -> vb --Eta reduce
    b' -> Lam v (normalize ta) b'
normalize (Pi v ta tb) = Pi v (normalize ta) (normalize tb)
normalize (App f a) = case normalize f of
    Lam v _ b -> subst v (normalize a) b
    f' -> App f' (normalize a)
normalize c = c

e `equiv` e' = igo (normalize e) (normalize e') (-1) where
    igo (Lam v ta b) (Lam v' ta' b') n = igo ta ta' n && igo (subst v (Var n)  b) (subst v' (Var n)  b') (pred n)
    igo (Pi v ta tb) (Pi v' ta' tb') n = igo ta ta' n && igo (subst v (Var n) tb) (subst v' (Var n) tb') (pred n)
    igo (App f a) (App f' a') n = igo f f' n && igo a a' n
    igo c c' n = c == c'

typeIn _ Star = return Box
typeIn _ Box  = Nothing
typeIn ctx (Var v) = lookup v ctx
typeIn ctx (Lam v ta b) = do
    tb <- typeIn ((v, ta):ctx) b
    let tf = Pi v ta tb
    _ttf <- typeIn ctx tf
    return tf
typeIn ctx (Pi v ta tb) = do
    tta <- typeIn ctx ta
    ttb <- typeIn ((v, ta):ctx) tb
    case (tta, ttb) of
        (Star, Star) -> return Star
        (Box , Star) -> return Star
        (Star, Box ) -> return Box
        (Box , Box ) -> return Box
        _            -> Nothing

typeIn ctx (App f a) = do
    (v, ta, tb) <- case typeIn ctx f of
        Just (Pi v ta tb) -> return (v, ta, tb)
        _                 -> Nothing
    ta' <- typeIn ctx a
    if ta `equiv` ta'
    then return $ subst v a tb
    else Nothing

typeOf = typeIn []
wellTyped e = typeOf e /= Nothing

id_ = Lam 0 Star (Var 0)
const_ = Lam 0 Star (Lam 1 Star (Var 1))

egEval = normalize id_
egType = typeOf id_

egEval' = normalize (App id_ const_)
egType' = typeOf egEval'
