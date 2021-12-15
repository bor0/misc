import math

with open('input') as f:
  L = f.read().split('\n')
  L = [ [ int(x) for x in a ] for a in L ]
  L = filter(lambda x: x, L) # empty elements

def get_times5_value(L, i, j, leni, lenj):
  value = L[i%leni][j%lenj] + int(j/lenj) + int(i/leni)
  if value > 9: value = value % 9
  return value

leni = len(L)
lenj = len(L[0])

# Initialize cost
cost = [ [ float('inf') for a in b*5 ] for b in L*5 ]
cost[0][0] = 0

# Process cost
for i in range(0, leni*5):
  for j in range(0, lenj*5):
    if (i, j) == (0, 0): continue
    cost[i][j] = get_times5_value(L, i, j, leni, lenj) + min(cost[i-1][j], cost[i][j-1])

print(cost[leni*5-1][lenj*5-1])

#TODO: bonus 9 on the final answer?
