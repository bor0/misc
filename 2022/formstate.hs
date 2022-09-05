{-# LANGUAGE MultiParamTypeClasses, TypeSynonymInstances, FlexibleInstances #-}

data ElementType = Href | Br | Input deriving (Show)

type Data = [(String, String)] -- map
data FieldState a = FieldState Data a deriving (Show)
data FormState a = FormState Data [a] deriving (Show)

-- Class at the value level
class Elements a b where
  getFieldType :: FieldState a -> b
  getFormType :: FormState (FieldState a) -> Int -> b
  getFormType (FormState _ a) n = getFieldType $ a !! n

----------------
-- Example usage

instance Elements String ElementType  where
  getFieldType (FieldState _ "br")    = Br
  getFieldType (FieldState _ "href")  = Href
  getFieldType (FieldState _ "input") = Input

-- Example fields
field1 = FieldState [("id", "foo")] "br"
field2 = FieldState [("id", "bar")] "href"

eg1 = getFieldType field1 :: ElementType
eg2 = getFieldType field2 :: ElementType

-- Example forms
egform1 = FormState [] [field1, field2]

eg3 = getFormType egform1 0 :: ElementType
eg4 = getFormType egform1 1 :: ElementType
