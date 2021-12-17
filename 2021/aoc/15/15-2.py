from queue import PriorityQueue

with open('input') as f:
  L = f.read().split('\n')
  L = [ [ int(x) for x in a ] for a in L ]
  L = filter(lambda x: x, L) # empty elements

def get_risk_wrap(L, i, j, leni, lenj):
  value = L[i%leni][j%lenj] + int(j/lenj) + int(i/leni)
  if value > 9: value = value % 9
  return value

def get_neighbors(L, i, j, leni, lenj):
  neighbors = []

  if i - 1 >= 0: neighbors.append((i-1,j))
  if j - 1 >= 0: neighbors.append((i,j-1))
  if i + 1 < leni: neighbors.append((i+1,j))
  if j + 1 < lenj: neighbors.append((i,j+1))

  return neighbors

def ultra_slow(L):
  leni = len(L)
  lenj = len(L[0])
  
  # Dijkstra starts here
  start_node = (0, 0)
  
  # Initialize cost
  # Default to infinity from start_node to each
  cost = { (i, j): float('inf') for i in range(0, leni*5) for j in range(0, lenj*5) }
  cost[start_node] = 0
  
  # Set of nodes to process and processed nodes
  nodes = set([start_node])
  processed = set()
  
  while nodes:
    # Check the node hasn't been processed yet
    (i, j) = node = nodes.pop()
    if node in processed: continue
    processed.add(node)
    print(len(processed))
  
    # Get neighbors
    neighbors = get_neighbors(L, i, j, leni*5, lenj*5)
  
    for (i, j) in neighbors:
      # Get current calculated distance and edge value
      cur = cost[node] + get_risk_wrap(L, i, j, leni, lenj)
      # Check and set if it's smaller than the current minimum
      cost[(i, j)] = min(cur, cost[(i, j)])
  
    # Add neighbors for processing
    nodes = nodes.union(neighbors)
  
  return cost[(leni*5-1, lenj*5-1)]

# Priority queue makes it faster!
def ultra_fast(L):
  leni = len(L)
  lenj = len(L[0])
  
  # Dijkstra starts here
  start_node = (0, 0)
  
  # Initialize cost
  # Default to infinity from start_node to each
  cost = { (i, j): float('inf') for i in range(0, leni*5) for j in range(0, lenj*5) }
  cost[start_node] = 0
  
  # Set of nodes to process and processed nodes
  nodes = PriorityQueue()
  nodes.put((0, start_node))
  processed = set()
  
  while not nodes.empty():
    # Check the node hasn't been processed yet
    (_, (i, j)) = (_, node) = nodes.get()

    if node in processed: continue
    processed.add(node)
  
    # Get neighbors
    neighbors = get_neighbors(L, i, j, leni*5, lenj*5)
  
    for neighbor in neighbors:
      (di, dj) = neighbor
      # Get current calculated distance and edge value
      new_cost = cost[node] + get_risk_wrap(L, di, dj, leni, lenj)
      old_cost = cost[neighbor]
      # Check and set if it's smaller than the current minimum
      if new_cost < old_cost:
        cost[neighbor] = new_cost
        # Add neighbors for processing
        nodes.put((new_cost, neighbor))

  #for node in processed: print(node)
  #for (i, j), v in cost.iteritems():
  #  print("%d,%d->%f" % (i, j, v))
  
  return cost[(leni*5-1, lenj*5-1)]

print(ultra_fast(L))
