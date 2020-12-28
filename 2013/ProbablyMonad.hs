data Probably x = Nope | Kinda x deriving (Show)

instance Monad Probably where
    Kinda x >>= f = f x
    Nope >>= f = Nope
    return = Kinda

add x y = x >>= (\x -> y >>= (\y -> return (x + y)))
-- Example: add (add (Kinda 1) (Kinda 2)) (Kinda 4)


-- Proof that "Probably" is a monad (i.e. it obeys monad laws):

-- 1. Left identity:
-- return a >>= f ≡ f a
-- "return a" by definition is "Kinda a", and so the bind operator is defined as "Kinda a >>= f ≡ f a".
-- So with these two definitions, we have shown that "return a >>= f ≡ f a".

-- 2. Right identity:
-- m >>= return ≡ m
-- If we let m equal "Kinda n", then we have "Kinda n >>= return ≡ Kinda n", but by definition of the binding operator,
-- we have that "Kinda n >>= return = return n", and so "return n". So, by definition of return, we have "Kinda n", which is m.

-- 3. Associativity:
-- (m >>= f) >>= g ≡ m >>= (\x -> f x >>= g)
-- If we let m equal "Kinda n", then we have:
-- LHS: (Kinda n >>= f) >>= g ≡ (f n) >>= g
-- RHS: Kinda n >>= (\x -> f x >>= g) ≡ (\x -> f x >>= g) n ≡ f n >>= g
