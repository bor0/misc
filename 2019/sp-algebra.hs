module Main where

-- As per
-- J. Pincus and J. M. Wing, "Towards an Algebra for Security Policies", 2005

-- Example algebra in action

-- The code can be improved, maybe set a class SP (Eq, Ord)? But it's for demo purposes anyway.

import Data.Set

data Principal = IEUser1 | IEUser2 | IEUser3 | OUser1 | OUser2 | OUser3 deriving (Eq, Ord, Show)
data Object    = Graphic deriving (Eq, Ord, Show)
data Right     = ViewRead | ViewForward deriving (Eq, Ord, Show)

type P = Principal
type O = Object
type R = Right

type SP = Set (P, O, R)

rights :: SP -> P -> O -> Set R
rights sp p o      = Data.Set.map (\(_, _, r) -> r) filteredSp
    where
    filteredSp     = Data.Set.filter (\(p', o', _) -> p == p' && o == o') sp

clash :: SP -> SP -> Bool
sp1 `clash` sp2    = sp1 /= sp2

obj :: SP -> Set O
obj                = Data.Set.map (\(p, o, r) -> o)

respects :: SP -> SP -> Bool
sp1 `respects` sp2 = all (\(p, o) -> rights sp1 p o `isSubsetOf` rights sp2 p o) pos
    where
    pos = [ (p, o) | p <- toList (prin sp1 `union` prin sp2), o <- toList (obj sp1 `union` obj sp2) ]

disrespects :: SP -> SP -> Bool
sp1 `disrespects` sp2 = not (sp1 `respects` sp2)

and :: SP -> SP -> SP
sp1 `and` sp2      = sp1 `intersection` sp2

or :: SP -> SP -> SP
sp1 `or` sp2       = sp1 `union` sp2

minus :: SP -> SP -> SP
sp1 `minus` sp2    = sp1 `difference` sp2

trumps :: SP -> SP -> SP
sp1 `trumps` sp2   = sp1

inherit :: SP -> P -> P -> SP
inherit sp p1 p2   = sp `union` Data.Set.filter f sp
    where
    f (p, o, r)    = (p1, o, r) `member` sp && p == p2

delegate :: SP -> P -> P -> SP
delegate sp p1 p2  = inherit sp p2 p1

prin :: SP -> Set P
prin               = Data.Set.map (\(p, o, r) -> p)

restrict :: SP -> Set P -> SP
restrict sp ps     = Data.Set.filter (\(p, _, _) -> p `member` ps) sp

revoke :: SP -> P -> SP
revoke sp p        = sp `restrict` (prin sp `difference` singleton p)

--------------

spOutlook = fromList [ (u, Graphic, r) | u <- [ OUser1, OUser2, OUser3 ], r <- [ ViewRead, ViewForward ] ]
spIE      = fromList [ (u, Graphic, r) | u <- [ IEUser1, IEUser2, IEUser3 ], r <- [ ViewRead, ViewForward ] ]

main = do
    print $ spIE `Main.and` spOutlook
    print $ spIE `Main.trumps` spOutlook
    print $ (spIE `Main.trumps` spOutlook) `disrespects` spOutlook

-- fromList []
-- fromList [(IEUser1,Graphic,ViewRead),(IEUser1,Graphic,ViewForward),(IEUser2,Graphic,ViewRead),(IEUser2,Graphic,ViewForward),(IEUser3,Graphic,ViewRead),(IEUser3,Graphic,ViewForward)]
-- True
-- *Main> 
