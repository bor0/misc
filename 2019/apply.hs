apply 0 _ _ = []
apply n f v = v : apply (n - 1) f (f v)

--  <lambdabot> iterate f x = x : iterate f (f x)


applyNtimes n f = foldr (.) id (replicate n f)
apply' n f v    = map (\i -> applyNtimes i f v) [0..n-1]

apply'' n f v = take n $ iterate f v

----------

f = map (+ 4)

test  = apply   5 f [1,2]
test2 = apply'  5 f [1,2]
test3 = apply'' 5 f [1,2]

main  = print test >> print (concat test)
main2 = print test2 >> print (concat test2)
