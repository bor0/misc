import Control.Applicative
import Control.Monad
import Text.JSON

{-
*Main> encode $ Test "Hi" 123
"{\"name\":\"Hi\",\"age\":123}"
*Main> decode $ encode $ Test "Hi" 123 :: Result Test
Ok (Test {name = "Hi", age = 123})
*Main> 
-}

(!) :: (JSON a) => JSObject JSValue -> String -> Result a
(!) = flip valFromObj

data Test = Test {
    name :: String
    , age :: Int
} deriving (Show)

instance JSON Test where
    readJSON (JSObject obj) =
        Test        <$>
        obj ! "name"  <*>
        obj ! "age"
    readJSON _ = mzero

    showJSON (Test name age) =
        JSObject $ toJSObject [ ("name", showJSON name)
                              , ("age", showJSON age) ]
