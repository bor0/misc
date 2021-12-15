with open('input') as f:
  L = f.read().split('\n')
  L = [ [ int(x) for x in a ] for a in L ]
  L = filter(lambda x: x, L) # empty elements

def get_risk_wrap(L, i, j, leni, lenj):
  value = L[i%leni][j%lenj] + int(j/lenj) + int(i/leni)
  if value > 9: value = value % 9
  return value

leni = len(L)
lenj = len(L[0])

# Initialize cost
cost = [ [ float('inf') for a in b*5 ] for b in L*5 ]
cost[0][0] = 0

for i in range(1, leni*5):
  cost[i][0] = get_risk_wrap(L, i, 0, leni, lenj) + cost[i-1][0]

for j in range(1, lenj*5):
  cost[0][j] = get_risk_wrap(L, 0, j, leni, lenj) + cost[0][j-1]

# Process cost
for i in range(1, leni*5):
  for j in range(1, lenj*5):
    cost[i][j] = get_risk_wrap(L, i, j, leni, lenj) + min(cost[i-1][j], cost[i][j-1])

print(cost[leni*5-1][lenj*5-1])

#TODO: extra 9 on the final answer?
