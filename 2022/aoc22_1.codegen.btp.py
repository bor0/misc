with open('input') as f:
  L = f.read().split('\n\n')
  L = [ x.split('\n') for x in L ]
  L = [ list(filter(lambda x: x, y)) for y in L ] # empty elements
  L = [ list(map(lambda x: int(x), y)) for y in L ]

def get_initial_axioms():
  return """## Axioms and rules
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

def calc_numbers(L):
  largest_number = max([ sum(x) for x in L ])
  
  budge_code = '# Representing all necessary numbers\n'
  for i in range(0, largest_number):
    budge_code += 'tm%d! : rTmS x=tm%d!\n' % (i + 1, i)

  return budge_code

def calc_lists(L):
  budge_code = '# Representing all the lists from the input\n'
  for i in range(0, len(L)):
    cur_L = list(reversed(L[i]))
    budge_code += 'tList%dStep0! : rTmNil\n' % (i + 1)
    for j in range(0, len(cur_L)-1):
      budge_code += 'tList%dStep%d! : rMkList x=tm%d!;y=tList%dStep%d!\n' % (i + 1, j + 1, cur_L[j], i + 1, j)
    budge_code += 'tList%d! : rMkList x=tm%d!;y=tList%dStep%d!\n' % (i + 1, cur_L[-1], i + 1, len(cur_L)-1)

  return budge_code

def calc_sums(L):
  budge_code = '# Representing all the sums of the lists\n'
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

  return budge_code

def combine_sums_into_list(L):
  budge_code = '# Combining all the sums into a single list\n'
  budge_code += 'tElvesSumsStep0! : rTmNil\n'
  step = 1
  for i in range(len(L), 1, -1):
    budge_code += 'tElvesSumsStep%d! : rMkList x=tElf%d!;y=tElvesSumsStep%d!\n' % (step, i, step - 1)
    step += 1
  budge_code += 'tElvesSums! : rMkList x=tElf1!;y=tElvesSumsStep%d!\n' % (len(L) - 1)
  return budge_code

def calc_maximum_number(L):
  budge_code = '# Take the maximum of the list tElvesSums!\n'
  budge_code += 'tElvesMaxStep0! : rMaxInit x=tElvesSums!\n'
  
  sum_step = len(L)
  step = 1
  max_sum = 0
  sums = [ sum(x) for x in L ]
  
  for suma in sums:
    if suma < max_sum:
      budge_code += 'tElvesMaxStep%d! : rLtZ x=tm%d!\n' % (step, max_sum - suma - 1)
      step += 1
      for i in range(0, suma):
        budge_code += 'tElvesMaxStep%d! : rLtS x=tm%d!;y=tm%d! tElvesMaxStep%d!\n' % (step, i, max_sum - suma + i, step - 1)
        step += 1
      sum_step -= 1
      budge_code += 'tElvesMaxStep%d! : rMaxRecL x=tm%d!;y=tElvesSumsStep%d!;z=tm%d! tElvesMaxStep%d! tElvesMaxStep%d!\n' % (step, suma, sum_step, max_sum, step - 1, step - suma - 2)
      suma = max_sum
    elif suma > max_sum:
      budge_code += 'tElvesMaxStep%d! : rLtZ x=tm%d!\n' % (step, suma - max_sum - 1)
      step += 1
      for i in range(0, max_sum):
        budge_code += 'tElvesMaxStep%d! : rLtS x=tm%d!;y=tm%d! tElvesMaxStep%d!\n' % (step, i, suma - max_sum + i, step - 1)
        step += 1
      sum_step -= 1
      budge_code += 'tElvesMaxStep%d! : rMaxRecR x=tm%d!;y=tElvesSumsStep%d!;z=tm%d! tElvesMaxStep%d! tElvesMaxStep%d!\n' % (step, suma, sum_step, max_sum, step - 1, step - max_sum - 2)
      max_sum = suma
    else:
      budge_code += 'tElvesMaxStep%d! : rMaxSame x=tm%d!;y=tElvesSumsStep%d! tElvesMaxStep%d!\n' % (step, suma, sum_step - 1, step - 1)
      sum_step -= 1
    step += 1
  
  budge_code += '\ntMaxElf : rMaxNil y=tm%d! tElvesMaxStep%d!' % (max_sum, step - 1)
  return budge_code

## Step 0. Initial axioms
budge_code = get_initial_axioms()

## Step 1. Represent all the numbers from [1, largest_number] in Budge
budge_code += calc_numbers(L) + '\n'

## Step 2. Represent all the lists from the input in Budge
budge_code += calc_lists(L) + '\n'

## Step 3. Represent all the sums of the lists in Budge
budge_code += calc_sums(L) + '\n'

## Step 4. Combine all the sums into a single list in Budge
budge_code += combine_sums_into_list(L) + '\n'

## Step 5. Calculate the maximum of the list
budge_code += calc_maximum_number(L)

print(budge_code)
