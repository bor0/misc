{-
A natural number is either 0 or n + 1, for n in Naturals
-}
data Naturals = N | S Naturals deriving (Show, Eq)

{-
(I) m + 0 = m
(II) m + (n + 1) = (m + n) + 1
-}
plus :: Naturals -> Naturals -> Naturals
plus m N = m
plus m (S n) = S $ plus m n

{-
1. Identity immediately follows from (I)

2. Associativity:

    a + (b + c) = (a + b) + c
    Induction on c:

    a + (b + 0) = (a + b) + 0
    From (I) it follows that a + (b) = (a + b) => (a + b) = (a + b)

    Assume it holds for k:
    a + (b + k) = (a + b) + k

    Then it must also hold for k + 1:
    a + (b + (k + 1)) = (a + b) + (k + 1)

    RHS:
    If we set t = a + b, then we have t + (k + 1), which from II it follows that (t + k) + 1, i.e. ((a + b) + k) + 1
    From I.H. it follows that ((a + b) + k) + 1 = (a + (b + k)) + 1
    If we set t = b + k, then from II it follows that (a + t) + 1 = a + (t + 1), i.e. a + ((b + k) + 1)
    If we set t = b + k, then from II it follows that a + ((b + k) + 1) = a + (b + (k + 1)), which is equal to the LHS.
-}

-- | helper method to convert integer to natural number
intToNaturals 0 = N
intToNaturals x = S $ intToNaturals (x - 1)

-- | helper method to convert natural number to integer
naturalsToInt N = 0
naturalsToInt (S m) = 1 + naturalsToInt m

example1 = let (x, y, z) = (intToNaturals 123, intToNaturals 456, intToNaturals 789) in (x `plus` y) `plus` z == x `plus` (y `plus` z)
