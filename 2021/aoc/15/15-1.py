with open('input') as f:
  L = f.read().split('\n')
  L = [ [ int(x) for x in a ] for a in L ]
  L = filter(lambda x: x, L) # empty elements

leni = len(L)
lenj = len(L[0])

# Initialize cost
cost = [ [ float('inf') for a in b*5 ] for b in L*5 ]
cost[0][0] = 0

# Process cost
for i in range(0, leni):
  for j in range(0, lenj):
    if (i, j) == (0, 0): continue
    cost[i][j] = L[i][j] + min(cost[i-1][j], cost[i][j-1])

print(cost[leni-1][lenj-1])
