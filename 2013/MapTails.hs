tails [] = [[]]
tails x = x : tails (tail x)

test = [("1", "boro"), ("2", "diksi"), ("3", "zaki")]

getvalue :: String -> [(String, String)] -> String
getvalue _ [] = []
getvalue k (x:xs)
    | fst x == k = snd x
    | otherwise = getvalue k xs