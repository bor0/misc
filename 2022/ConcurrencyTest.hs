module ConcurrencyTest where
import Control.Concurrent

io1 = return $ 3 + 4 :: IO Int
io2 = return $ 4 + 5 :: IO Int
io3 = return $ 5 + 6 :: IO Int
io4 = return $ 6 + 7 :: IO Int

serial = mapM (>>= print) [io1, io2, io3, io4]
parallel = mapM (>>= forkIO . print) [io1, io2, io3, io4]
