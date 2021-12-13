---
title: "Advent of Code #8"
author: "Boro Sitnikovski"
---

```
This is a literate Haskell file. You can build an HTML with pandoc by running `pandoc -s advent_of_code8.lhs -o advent_of_code8.html` or run it with stack with `stack repl advent_of_code8.lhs`.
```

In this post we'll tackle the 8th problem of AoC2020, [Handheld Halting](https://adventofcode.com/2020/day/8).

As usual, we start with the dependencies.

> import System.IO
> import Control.Monad
>
> import qualified Data.Map as Map
> import Data.List.Utils

Now, we need to implement a simple evaluator that accepts three commands: `acc`, `jmp`, and `not`. Here are the data types for that:

> data Instruction = Nop | Acc | Jmp deriving (Show)
> data Command = I Instruction Int deriving (Show)
> type Program = [Command]

Additionally, the program has state - the accumulator.

> type Context = Map.Map String Int

In addition to the accumulator we'll keep the instruction pointer. Here's a function to get the initial state:

> getEmptyCtx :: Context
> getEmptyCtx = Map.fromList [ ("acc", 0), ("IP", 0) ]

We can now proceed to the evaluation, handling every case from the `Instruction` data type:

> eval :: Context -> Command -> Context
> eval ctx (I Nop n) = incIP 1 ctx
> eval ctx (I Acc n) = let acc = ctx Map.! "acc"
>                      in Map.insert "acc" (acc + n) $ incIP 1 ctx
> eval ctx (I Jmp n) = incIP n ctx

We need to keep increasing the instruction pointer with each evaluation, so the helper `incIP` is defined as following:

> incIP :: Int -> Context -> Context
> incIP n ctx = let ip = ctx Map.! "IP" in Map.insert "IP" (ip + n) ctx

Here are a few examples of evaluation:

```
Main> eval getEmptyCtx $ I Acc 1
fromList [("IP",1),("acc",1)]
Main> eval getEmptyCtx $ I Acc 10
fromList [("IP",1),("acc",10)]
Main> eval getEmptyCtx $ I Nop 10
fromList [("IP",1),("acc",0)]
```

Now, `eval` just executes a single command, so we need a function to run a program (execute a list of commands). Here's the function type:

> run :: Program -> Either (Context, [Int]) (Context, [Int])

This function will return a `Left` when it does not terminate, and `Right` otherwise. Additionally, it will contain a list of the previously executed instruction pointers - this will be used for part two because it will show the last line before the infinite loop happened so we know where it happens.

The task defined terminating programs in such a way (command being executed more than once) that this solution is applicable. In general, it's not a good definition for what a terminating program is.

> run cmds = go cmds getEmptyCtx [] where
>   go cs ctx prevIPs = let ip = ctx Map.! "IP" in go' ip where
>      go' ip
>          | ip >= length cs   = Right (ctx, prevIPs) -- if the instruction pointer out of bounds, the program terminated
>          | ip `elem` prevIPs = Left (ctx, prevIPs)  -- if the instruction pointer was already executed, conclude infinite loop
>          | otherwise         = let newctx = eval ctx (cs !! ip) in
>                                    go cs newctx (ip:prevIPs)

Here's an example:

```
Main> run [I Acc 10]
Right (fromList [("IP",1),("acc",10)],[0])
Main> run [I Acc 10, I Acc 5]
Right (fromList [("IP",2),("acc",15)],[1,0])
Main> run [I Acc 10, I Acc 5, I Jmp (-1)]
Left (fromList [("IP",1),("acc",15)],[2,1,0])
```

In the first and the second case, it returned `Right` because the program terminated. Also note how the state changed (`acc` is 10 and 15 respectively). However, in the third case, we get a `Left` because an infinite loop happened. The last executed instruction pointers were `[2,1,0]` so IP 2 was executed twice.

We proceed with writing the parsing function:

> parseLine :: String -> Command
> parseLine s = let [cmd, number] = split " " s in go cmd number where
>   go "jmp" number   = I Jmp $ readNumber number
>   go "acc" number   = I Acc $ readNumber number
>   go "nop" _        = I Nop 0
>   readNumber ('+':n) = read n
>   readNumber number  = read number

Together with usual `main` to read from file, parse it and execute it:

> main = do
>         handle <- openFile "input" ReadMode
>         contents <- hGetContents handle
>         let program = map parseLine $ lines contents
>         print $ run program
>         hClose handle

An example `input` file:

```
acc 10
nop 123
jmp -1
```

Running `main` on that example file returns `Left (fromList [("IP",1),("acc",10)],[2,1,0])`.
