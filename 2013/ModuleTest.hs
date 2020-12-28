-- Used by ModuleExample.hs
module ModuleTest
( hello, exportme )
where

hello :: String
hello = "Hello World"

notexported :: String
notexported = "I'm hidden"

exportme :: String
exportme = notexported