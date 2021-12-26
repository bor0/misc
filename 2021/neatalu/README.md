NeatALU
-------

An attempt of tackling [AoC 24 2021](https://adventofcode.com/2021/day/24).

I thought I could express the program with a single expression, and then use an optimization function (with some fixed set of rules) to simplify it.

This is what the `run` ([String]->Inputs->State) (for input 9), `calcState` ([String]->State) and `runState` (State->Inputs->State)  output, respectively:

```
State {varW = 1, varX = 0, varY = 0, varZ = 1, inputs = ["B","C","D","E","F","G","H","I","J","K","L","M","N"]}
State {varW = ((((A/2)/2)/2)%2), varX = (0+((A/2)/2)%2), varY = (0+(A/2)%2), varZ = (0+A%2), inputs = ["B","C","D","E","F","G","H","I","J","K","L","M","N"]}
State {varW = 1, varX = 0, varY = 0, varZ = 1, inputs = ["B","C","D","E","F","G","H","I","J","K","L","M","N"]}
```

Now, if we try to optimize `varX` within the calculated state using `optimize`, we get:

```
State {varW = ((A/8)%2), varX = ((A/4)%2), varY = ((A/2)%2), varZ = (A%2), inputs = ["B","C","D","E","F","G","H","I","J","K","L","M","N"]}
```

Seemed to work nicely with small programs. When I tried it on the actual input, it reduced the program size but was still big to process.

Anyway, it was fun :)
