-- idris --codegen node leftpad.idr -o leftpad.js

import Data.Vect
import Data.String

data Padding : (s : List Char) -> (target : Nat) -> Type where
    Pad : (pad : Nat) -> Padding s (length s + pad)
    Nop : Padding (ys ++ x :: xs) (length ys)

padding : (s : List Char) -> (target : Nat) -> Padding s target
padding       []     t  = Pad t
padding (x :: xs)    Z  = Nop {ys = []}
padding (x :: xs) (S t) with (padding xs t)
    padding (x :: xs) (S (length xs + p))        | Pad p = Pad p
    padding (y :: ys ++ z :: zs) (S (length ys)) | Nop   = Nop {ys=y::ys}

pad : (s : List Char) -> (c : Char) -> (target : Nat) -> List Char
pad s c target with (padding s target)
    pad s c (length s + pad)          | Pad pad  = replicate pad c ++ s
    pad (ys ++ x :: xs) c (length ys) | Nop {ys} = ys ++ x :: xs

main : IO ()
main = do
    putStrLn "Enter string: "
    str <- getLine
    putStrLn "Enter char: "
    char <- getLine
    putStrLn "Enter length: "
    number <- getLine
    case (parseInteger number) of
        Just number' => putStrLn $ pack $ pad (unpack str) 'x' (fromIntegerNat number')
        _            => putStrLn "Not a valid number"
