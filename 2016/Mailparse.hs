import Codec.MIME.Parse
import qualified Data.Text as T
import Codec.MIME.Type

getParamName :: T.Text -> [MIMEParam] -> T.Text
getParamName param (x:xs) = if paramName x == param then paramValue x else getParamName param xs
getParamName _     []     = T.pack ""

fromMimeContent :: MIMEContent -> T.Text
fromMimeContent (Single x) = x
fromMimeContent (Multi (x:xs)) = if content == T.pack "" then fromMimeContent (Multi xs) else content
    where
    content = fromMimeContent (mime_val_content x)
fromMimeContent _          = T.pack ""

main = do
    mime <- getContents
--readFile "testmail"
    let parsed_mime = parseMIMEMessage $ T.pack mime
    let headers = mime_val_headers parsed_mime
    let content_array = T.words $ fromMimeContent $ mime_val_content parsed_mime
    let subject_array = T.words $ getParamName (T.pack "subject") headers
    let possible_recipients = map (T.toLower . T.tail) $ filter (('@' ==) . T.head) $ content_array ++ subject_array
    let url = filter (\x -> T.isPrefixOf (T.pack "www") x || T.isPrefixOf (T.pack "http") x) content_array
    let intro = T.unwords $ filter (\x -> T.head x /= '@') $ takeWhile (\x -> not (T.pack "http" `T.isInfixOf` x || T.pack "www" `T.isInfixOf` x)) content_array
    let from' = getParamName (T.pack "from") headers
    let from = if '<' `elem` (T.unpack from') then (T.tail . T.init) (T.dropWhile (/= '<') from') else from'
    print (from, possible_recipients, url, intro)
