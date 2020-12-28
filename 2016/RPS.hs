data Element = Rock | Paper | Scissors deriving Show
data Player = First | Second | Tie deriving Show

play :: Element -> Element -> Player
play Rock Paper = Second
play Paper Rock = First
play Rock Scissors = First
play Scissors Rock = Second
play Paper Scissors = Second
play Scissors Paper = First
play _ _ = Tie
