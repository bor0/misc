with open('input') as f:
  L = f.read().split('\n')
  L = [ [ int(x) for x in a ] for a in L ]
  L = filter(lambda x: x, L) # empty elements

leni = len(L)
lenj = len(L[0])

# Initialize cost
cost = [ [ float('inf') for a in b ] for b in L ]
cost[0][0] = 0

for i in range(1, leni):
  cost[i][0] = L[i][0] + cost[i-1][0]

for j in range(1, lenj):
  cost[0][j] = L[0][j] + cost[0][j-1]

# Process cost
for i in range(1, leni):
  for j in range(1, lenj):
    if (i, j) == (0, 0): continue
    cost[i][j] = L[i][j] + min(cost[i-1][j], cost[i][j-1])

print(cost[leni-1][lenj-1])
