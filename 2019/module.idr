module CharRange

%default total
%access export

data CharRange : Char -> Char -> Type where
  C : Char -> CharRange min max

ofChar : Char -> CharRange min max
ofChar c =
  if min <= c && c <= max
  then C c
  else C min

asChar : CharRange min max -> Char
asChar (C c) =
  if min <= c && c <= max
  then c
  else min

-- props to @keithtpinson
-- Idris> the (CharRange 'a' 'z') (ofChar 'a')
-- C 'a' : CharRange 'a' 'z'
-- Idris> the (CharRange 'a' 'm') (ofChar 'z')
-- C 'a' : CharRange 'a' 'm'
-- module> asChar $ the (CharRange 'a' 'z') (C 'a')
-- 'a' : Char
-- module> asChar $ the (CharRange 'a' 'm') (C 'z')
-- 'a' : Char
