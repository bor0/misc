import Control.Monad
import Language.Haskell.TH

tupleN n = do
    x <- newName "x"
    let tupleContents = replicate n (VarE x)
    return $ LamE [VarP x] (TupE tupleContents)

genTupleN n = runQ $ tupleN n

{-
Main> :set -XTemplateHaskell
Main> $(genTupleN 1) 1
1
Main> $(genTupleN 2) 1
(1,1)
Main> $(genTupleN 3) 1
(1,1,1)
Main> $(genTupleN 10) 1
(1,1,1,1,1,1,1,1,1,1)
Main> 
-}
