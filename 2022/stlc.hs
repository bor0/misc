-- https://bor0.wordpress.com/2019/03/19/writing-a-lambda-calculus-evaluator-in-haskell/
-- https://bor0.wordpress.com/2019/03/21/writing-a-lambda-calculus-type-checker-in-haskell/
import Data.List ((\\), nub)

type VarName = String
type TyEnv = [(String, Type)] -- Type env

data Term =
  TmVar VarName
  | TmAbs VarName Type Term
  | TmApp Term Term deriving Eq

isTmVar (TmVar _) = True
isTmVar _ = False

instance Show Term where
  show (TmVar x) = x
  show (TmAbs v ty tm) = "\\" ++ v ++ " -> " ++ show tm
  show (TmApp tm1 tm2) = if isTmVar tm1 then show tm1 else ("(" ++ show tm1 ++ ")") ++ " " ++
                         if isTmVar tm2 then show tm2 else ("(" ++ show tm2 ++ ")")

data Type =
   TyVar
   | TyArr Type Type deriving (Eq)

instance Show Type where
  show TyVar = "a"
  show (TyArr x y) = "(" ++ show x ++ ") -> (" ++ show y ++ ")"

eval :: Term -> Term
eval (TmApp (TmAbs x _ t12) v2) = subst x t12 v2 -- E-AppAbs
eval (TmApp t1 t2)              = let t1' = eval t1 in TmApp t1' t2 -- E-App1
eval (TmVar x)                  = TmVar x
eval x = error $ "No rule applies: " ++ show x

-- subst VarName in Term to Term
subst :: VarName -> Term -> Term -> Term
subst x (TmVar v) newVal
    | x == v    = newVal
    | otherwise = TmVar v
subst x (TmAbs y t t1) newVal
    | x == y                                  = TmAbs y t t1
    | x /= y && (y `notElem` freeVars newVal) = TmAbs y t (subst x t1 newVal)
    | otherwise                               = error $ "Cannot substitute '" ++ show x ++ "' in term '" ++ show (TmAbs y t t1) ++ "'"
subst x (TmApp t1 t2) newVal = TmApp (subst x t1 newVal) (subst x t2 newVal)

freeVars :: Term -> [VarName]
freeVars (TmVar x) = [x]
freeVars (TmAbs x _ t1) = nub (freeVars t1) \\ [x]
freeVars (TmApp t1 t2) = freeVars t1 ++ freeVars t2

typeOf :: TyEnv -> Term -> Either String Type
typeOf env (TmVar n) =
    case getTypeFromEnv env n of
        Just t -> Right t
        _      -> error $ "No var found in env: " ++ show n
typeOf env (TmAbs n t1 te) =
    let newEnv = addType n t1 env
        t2 = typeOf newEnv te in
        case t2 of
            Right t2 -> Right $ TyArr t1 t2
            _        -> Left "Unsupported type for TmAbs"
typeOf env (TmApp t1 t2)   =
    let t1' = typeOf env t1
        t2' = typeOf env t2 in
        case t1' of
           Right (TyArr a b) | Right a == t2' -> Right b
           Right (TyArr a _)                  -> Left $ "Type mismatch between " ++ show t1' ++ " and " ++ show t2'
           _                                  -> Left "Unsupported type for TmApp"

addType :: String -> Type -> TyEnv -> TyEnv
addType varname b env = (varname, b) : env
 
getTypeFromEnv :: TyEnv -> String -> Maybe Type
getTypeFromEnv [] _ = Nothing
getTypeFromEnv ((varname', b) : env) varname = if varname' == varname then Just b else getTypeFromEnv env varname

egTypeEnv = addType "fix" (TyArr (TyArr TyVar TyVar) TyVar) $ addType "x" TyVar []
lcid = TmAbs "x" TyVar (TmVar "x")
egTypeCheck = typeOf egTypeEnv (TmApp lcid (TmVar "x"))
egEval = eval (TmApp lcid (TmVar "x"))

fix = let t1 = TmAbs "x" TyVar (TmApp (TmVar "f") (TmApp (TmVar "x") (TmVar "x"))) in TmAbs "f" TyVar (TmApp t1 t1)
fixT = getTypeFromEnv egTypeEnv "fix"

egFix = TmApp fix lcid
egFixEval = eval egFix
egFixEval' = eval egFixEval
egFixEval'' = eval egFixEval'
