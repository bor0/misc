with open('input') as f:
  L = f.read().split('\n')
  L = [ [ int(x) for x in a ] for a in L ]
  L = filter(lambda x: x, L) # empty elements

def increase_all(L):
  return [ [ x+1 for x in l ] for l in L ]

def bounds_check(x, y, l1, l2):
  return x in l1 and y in l2

def get_flashes(L, l1, l2):
  return [ (x, y) for x in l1 for y in l2 if L[x][y] > 9 ]

def count_flashes(L):
  return len( [ x for a in L for x in a if x == 0 ] )

def increase_flashes(L, l1, l2):
  for (x, y) in get_flashes(L, l1, l2):
    L[x][y] = float('-inf')
    around = [ (x + dx, y + dy) for dx in range(-1, 2) for dy in range(-1, 2) if bounds_check(x + dx, y + dy, l1, l2) and (dx, dy) != (0, 0) ]
    for (newx, newy) in around: L[newx][newy] += 1

  return L

def step(L):
  L = increase_all(L)

  l1 = range(0, len(L))
  l2 = range(0, len(L[0]))

  while get_flashes(L, l1, l2):
    L = increase_flashes(L, l1, l2)
    # those in L with value of -inf have flashed

  return [ [ max(0, x) for x in a ] for a in L ] # -inf to zero

suma = 0
n = 0
while n != 100:
  n = n + 1
  L = step(L)
  suma = suma + count_flashes(L)

print(suma)
