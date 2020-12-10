import Data.Function (fix)
import Data.List (nub, sort)
import qualified Data.Map as Map
import Data.Maybe (isJust, fromJust)

list = [ 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4 ]

list2 = [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]

list3 = [ 114, 51, 122, 26, 121, 90, 20, 113, 8, 138, 57, 44, 135, 76, 134, 15, 21, 119, 52, 118, 107, 99, 73, 72, 106, 41, 129, 83, 19, 66, 132, 56, 32, 79, 27, 115, 112, 58, 102, 64, 50, 2, 39, 3, 77, 85, 103, 140, 28, 133, 78, 34, 13, 61, 25, 35, 89, 40, 7, 24, 33, 96, 108, 71, 11, 128, 92, 111, 55, 80, 91, 31, 70, 101, 14, 18, 12, 4, 84, 125, 120, 100, 65, 86, 93, 67, 139, 1, 47, 38 ]

-- Part one
countAdapterDifferences :: [Int] -> (Int, Int, Int)
countAdapterDifferences joltages
  | 1 `elem` joltages = go 1 joltages' (1, 0, 0)
  | 2 `elem` joltages = go 2 joltages' (0, 1, 0)
  | otherwise = go 3 joltages' (0, 0, 1)
  where
  joltages' = (maximum joltages + 3) : joltages
  go n l acc@(d1, d2, d3)
      | (n + 1) `elem` l = go (n + 1) l (d1 + 1, d2, d3)
      | (n + 2) `elem` l = go (n + 2) l (d1, d2 + 1, d3)
      | (n + 3) `elem` l = go (n + 3) l (d1, d2, d3 + 1)
  go _ _ acc = acc

-- Part two, bruteforce, works fine on list, slower on list2, not applicable on list3 (actual input)
countAdapterCombinations :: [Int] -> Int
countAdapterCombinations joltages = length $ nub lists where
  lists = (if 1 `elem` joltages then go 1 [1] joltages else []) ++
          (if 2 `elem` joltages then go 2 [2] joltages else []) ++
          (if 3 `elem` joltages then go 3 [3] joltages else [])
  go n path joltages =
    (if n + 1 `elem` joltages then go (n + 1) ((n+1):path) joltages else ([path | validPath path]))
    ++ (if n + 2 `elem` joltages then go (n + 2) ((n+2):path) joltages else ([path | validPath path]))
    ++ (if n + 3 `elem` joltages then go (n + 3) ((n+3):path) joltages else ([path | validPath path]))
    where validPath p = maximum joltages `elem` p

-- Part two good solution with recurrent relation but I need to learn how to apply Haskell memoization :(
countAdapterCombinations' :: [Integer] -> Integer
countAdapterCombinations' joltages = let joltages' = go joltages' (maximum joltages') where
  joltages' = 0 : (3 + maximum joltages) : joltages
  go joltages n
    | n == 1 || n == 0 = 1
    | n `elem` joltages = (if n - 1 `elem` joltages then go joltages (n - 1) else 0)
                        + (if n - 2 `elem` joltages then go joltages (n - 2) else 0)
                        + (if n - 3 `elem` joltages then go joltages (n - 3) else 0)
    | otherwise = 0

memoize :: (Int -> a) -> (Int -> a)
memoize f = (map f [0 ..] !!)

countAdapterCombinations'' :: [Int] -> Int
countAdapterCombinations'' joltages = fix (memoize . go joltages') (maximum joltages') where
  joltages' = 0 : (3 + maximum joltages) : joltages
  go joltages f n
    | n == 1 || n == 0 = 1
    | n `elem` joltages = (if n - 1 `elem` joltages then f (n - 1) else 0)
                        + (if n - 2 `elem` joltages then f (n - 2) else 0)
                        + (if n - 3 `elem` joltages then f (n - 3) else 0)
    | otherwise = 0

-- Same solution in Python (countAdapterCombinations'')
{-
def prepare_input(input_list):
  l = input_list[:]
  l.append(max(l)+3)
  l.append(0)
  return l

memo = {}

def count_adapter_combinations(n, adapters):
  if n in memo:
    return memo[n]

  if n == 1 or n == 0:
    return 1

  s = 0

  if n in adapters:
    s += count_adapter_combinations(n - 1, adapters) if (n - 1) in adapters else 0
    s += count_adapter_combinations(n - 2, adapters) if (n - 2) in adapters else 0
    s += count_adapter_combinations(n - 3, adapters) if (n - 3) in adapters else 0
  else:
    return 0

  memo[n] = s
  return s

def real_count(adapters):
  newl = prepare_input(adapters)
  return count_adapter_combinations(max(newl), newl)

print(real_count(list3))
-}
