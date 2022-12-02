with open('input') as f:
  L = f.read().split('\n\n')
  L = [ x.split('\n') for x in L ]
  L = [ list(filter(lambda x: x, y)) for y in L ] # empty elements
  L = [ list(map(lambda x: int(x), y)) for y in L ]

budge_code = """## Axioms and rules
# Zero is a natural number (term)
rTmZ : 0
tm0! : rTmZ

# Successor
rTmS : S(x) # term

# Inequality
rLtZ : LT(0, S(x))
rLtS : LT(x, y) -> LT(S(x), S(y))

# Constructing lists
rMkList : (x y)

# NIL (term)
rTmNil : NIL

# Summing lists
rSumInit : SUM(0, z)
rSumRec : SUM(x, (S(y) z)) -> SUM(S(x), (y z))
rSumRecSkip : SUM(x, (0 z)) -> SUM(x, z)
rSumNil : SUM(x, NIL) -> x

# Maximum of a list
rMaxInit : MAX(x, 0)
rMaxRecL : LT(x, z) -> MAX((x y), z) -> MAX(y, z)
rMaxRecR : LT(z, x) -> MAX((x y), z) -> MAX(y, x)
rMaxSame : MAX((x y), x) -> MAX(y, x)
rMaxNil : MAX(NIL, y) -> y

## Derived theorems
"""

## Step 1. Represent all the numbers from [1, largest_number] in Budge
largest_number = max([ sum(x) for x in L ])

budge_code += '# Representing all necessary numbers\n'
for i in range(1, largest_number + 1):
  budge_code += 'tm%d! : rTmS x=tm%d!\n' % (i, i - 1)

budge_code += '\n'

## Step 2. Represent all the lists from the input in Budge
budge_code += '# Representing all the lists from the input\n'
for i in range(0, len(L)):
  cur_L = list(reversed(L[i]))
  budge_code += 'tList%dStep0! : rTmNil\n' % (i + 1)
  for j in range(0, len(cur_L)-1):
    budge_code += 'tList%dStep%d! : rMkList x=tm%d!;y=tList%dStep%d!\n' % (i + 1, j + 1, cur_L[j], i + 1, j)
  budge_code += 'tList%d! : rMkList x=tm%d!;y=tList%dStep%d!\n' % (i + 1, cur_L[-1], i + 1, len(cur_L)-1)

budge_code += '\n'

## Step 3. Represent all the sums of the lists in Budge
budge_code += '# Representing all the sums of the lists\n'
for i in range(0, len(L)):
  cur_L = L[i]
  budge_code += 'tList%dSumStep0! : rSumInit z=tList%d!\n' % (i + 1, i + 1)
  step = 1
  suma = 0
  for j in range(0, len(cur_L)):
    for k in range(cur_L[j], 0, -1):
      budge_code += 'tList%dSumStep%d! : rSumRec x=tm%d!;y=tm%d!;z=tList%dStep%d! tList%dSumStep%d!\n' % (i + 1, step, suma, k - 1, i + 1, len(cur_L) - j - 1, i + 1, step - 1)
      suma += 1
      step += 1
    budge_code += 'tList%dSumStep%d! : rSumRecSkip x=tm%d!;z=tList%dStep%d! tList%dSumStep%d!\n' % (i + 1, step, suma, i + 1, len(cur_L) - j - 1, i + 1, step - 1)
    step += 1
  budge_code += 'tElf%d! : rSumNil x=tm%d! tList%dSumStep%d!\n' % (i + 1, suma, i + 1, step - 1)

budge_code += '\n'

## Step 4. Combine all the sums into a single list in Budge
budge_code += '# Combining all the sums into a single list\n'
budge_code += 'tElvesSumsStep0! : rTmNil\n'
step = 1
for i in range(len(L), 1, -1):
  budge_code += 'tElvesSumsStep%d! : rMkList x=tElf%d!;y=tElvesSumsStep%d!\n' % (step, i, step - 1)
  step += 1
budge_code += 'tElvesSums! : rMkList x=tElf1!;y=tElvesSumsStep%d!\n' % (len(L) - 1)

elves_sums_steps = step - 1

budge_code += '\n'

## Step 5. Calculate the maximum of the list
budge_code += '# Take the maximum of the list tElvesSums!\n'
budge_code += 'tElvesMaxStep0! : rMaxInit x=tElvesSums!\n'

step = 1
cur_max = 0
sums = [ sum(x) for x in L ]

for i in range(0, len(sums)):
  el = sums[i]
  if cur_max == 0:
    budge_code += 'tElvesMaxStep%d! : rLtZ x=tm%d!\n' % (step, el - 1)
    step += 1
    budge_code += 'tElvesMaxStep%d! : rMaxRecR x=tm%d!;z=tm0!;y=tElvesSumsStep%d! tElvesMaxStep%d! tElvesMaxStep%d!\n' % (step, el, elves_sums_steps, step - 1, step - 2)
    cur_max = el
  elif el < cur_max:
    budge_code += 'tElvesMaxStep%d! : rLtZ x=tm%d!\n' % (step, cur_max - el - 1)
    step += 1
    for i in range(0, el):
      budge_code += 'tElvesMaxStep%d! : rLtS x=tm%d!;y=tm%d! tElvesMaxStep%d!\n' % (step, i, cur_max - el + i, step - 1)
      step += 1
    elves_sums_steps -= 1
    budge_code += 'tElvesMaxStep%d! : rMaxRecL x=tm%d!;y=tElvesSumsStep%d!;z=tm%d! tElvesMaxStep%d! tElvesMaxStep%d!\n' % (step, el, elves_sums_steps, cur_max, step - 1, step - el - 2)
    el = cur_max
  elif el > cur_max:
    budge_code += 'tElvesMaxStep%d! : rLtZ x=tm%d!\n' % (step, el - cur_max - 1)
    step += 1
    for i in range(0, cur_max):
      budge_code += 'tElvesMaxStep%d! : rLtS x=tm%d!;y=tm%d! tElvesMaxStep%d!\n' % (step, i, el - cur_max + i, step - 1)
      step += 1
    elves_sums_steps -= 1
    budge_code += 'tElvesMaxStep%d! : rMaxRecR x=tm%d!;y=tElvesSumsStep%d!;z=tm%d! tElvesMaxStep%d! tElvesMaxStep%d!\n' % (step, el, elves_sums_steps, cur_max, step - 1, step - cur_max - 2)
    cur_max = el
  else:
    budge_code += 'tElvesMaxStep%d! : rMaxSame x=tm%d!;y=tElvesSumsStep%d! tElvesMaxStep%d!\n' % (step, el, elves_sums_steps - 1, step - 1)
    elves_sums_steps -= 1
  step += 1

budge_code += 'tMaxElf : rMaxNil y=tm%d! tElvesMaxStep%d!\n' % (cur_max, step - 1)

print(budge_code)
