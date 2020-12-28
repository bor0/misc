{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text    as T
import qualified Data.Text.IO as T
import Data.String (IsString)

main = getLine >>= T.putStrLn . T.pack . foldr ((++) . f) []

f :: IsString a => Char -> a
f chr = case y of
    [] -> ""
    x -> snd $ head x
    where
    y = filter ((chr ==) . fst) [('a', "а"), ('b', "бе"), ('c', "це"), ('d', "де"), ('e', "е"), ('f', "еф"), ('g', "ѓе"), ('h', "ха"), ('i', "и"), ('j', "јод"), ('k', "ка"), ('l', "ел"), ('m', "ем"), ('n', "ен"), ('o', "о"), ('p', "пе"), ('q', "ку"), ('r', "ер"), ('s', "ес"), ('t', "те"), ('u', "у"), ('v', "ве"), ('w', "дуплове"), ('x', "икс"), ('y', "ипсилон"), ('z', "зет")]
