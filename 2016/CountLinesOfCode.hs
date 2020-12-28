import System.Directory
import Control.Monad (filterM, mapM, liftM)
import System.FilePath ((</>))

getDirsRec :: FilePath -> IO [FilePath]
getDirsRec d = do
    dirContents <- getDirectoryContents d
    let dirContents' = [ d </> x | x <- dirContents, x /= ".", x /= ".." ]
    dirs' <- mapM dirRec dirContents'
    return (concat dirs' ++ [d])
    where
        dirRec n = do
            isDir <- doesDirectoryExist n
            if isDir then getDirsRec n
            else return []

getFiles :: FilePath -> IO [FilePath]
getFiles d = do
    dirContents <- getDirectoryContents d
    filterM doesFileExist (map (d </>) dirContents)

getLOC :: FilePath -> IO Int
getLOC f = (length . lines) `fmap` readFile f

main = liftM sum (getDirsRec "." >>= mapM getFiles >>= mapM getLOC . concat)