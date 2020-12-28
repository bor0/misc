import Network.CGI

import Text.XHtml
import Data.Digest.Pure.MD5 (md5)
import Data.ByteString.Lazy.Char8 (pack)

import Control.Monad
import Database.HDBC
import Database.HDBC.MySQL

sqlMd :: [Char] -> String
sqlMd password = show $ (md5.pack) password

checkUser :: String -> [Char] -> IO Bool
checkUser username password =
   do conn <- connectMySQL defaultMySQLConnectInfo {
                  mysqlHost = "localhost",
                  mysqlDatabase = "test",
                  mysqlUser = "root",
                  mysqlPassword = "123456",
                  mysqlUnixSocket = "/var/run/mysqld/mysqld.sock" }
      rows <- quickQuery' conn "SELECT username FROM users WHERE username = ? AND password = ?" [SqlString username, SqlString (sqlMd password)]
      return (length rows /= 0)

checkUser' :: Maybe String -> Maybe [Char] -> IO Bool
checkUser' (Just username) (Just password) = checkUser username password
checkUser' Nothing _ = return False
checkUser' _ Nothing = return False
 
inputForm :: Html
inputForm = form << [paragraph << ("My name and password is " +++ textfield "name" +++ textfield "pass"), submit "" "Submit"]

authSuccess :: Html
authSuccess = "Authentication is successful!" +++ br

page :: (HTML a, HTML a1) => a -> a1 -> Html
page t u = header << thetitle << t +++ body << u

printOutput x = output . renderHtml $ page "Input example" x

cgiMain = do username <- getInput "name"
             password <- getInput "pass"
             res <- liftIO $ checkUser' username password
             printOutput $ if res then authSuccess else inputForm
 
main = runCGI $ handleErrors cgiMain
