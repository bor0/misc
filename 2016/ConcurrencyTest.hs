module ConcurrencyTest where
import Control.Concurrent

io1 = return $ 3 + 4 :: IO Int
io2 = return $ 4 + 5 :: IO Int
io3 = return $ 5 + 6 :: IO Int
io4 = return $ 6 + 7 :: IO Int

(|||) a b = do
    x <- newEmptyMVar
    y <- newEmptyMVar
    a >>= \z -> forkIO $ putMVar x z
    b >>= \z -> forkIO $ putMVar y z
    x' <- takeMVar x
    y' <- takeMVar y
    return (x', y')

main = (io1 ||| io2) ||| (io2 ||| io3)
