"""
   6
 A---B  2
 |   |\
2|  9| E
 |   |/
 C---D  1
   5
"""
graph = {
 # node1: [(edge1, distance1), ...]
 'a': [('b', 6), ('c', 2)],
 'b': [('a', 6), ('e', 2), ('d', 9)],
 'c': [('a', 2), ('d', 5)],
 'd': [('c', 5), ('b', 9), ('e', 1)],
 'e': [('b', 2), ('d', 1)]
}

def dijkstra(graph, start_node):
  # Set of nodes to process and processed nodes
  nodes = set([start_node])
  processed = set()

  # Initialize distances
  # Default to infinity from start_node to each
  dists = {v : float('inf') for v in graph.keys()}
  dists[start_node] = 0

  while nodes:
    # Check the node hasn't been processed yet
    node = nodes.pop()
    if node in processed: continue
    processed.add(node)

    # Get neighbors
    neighbors = graph[node]

    for (name, value) in neighbors:
      # Get current calculated distance and edge value
      cur = dists[node] + value
      # Check and set if it's smaller than the current minimum
      dists[name] = min(cur, dists[name])
      print("Distance from %s to %s is %d" % (node, name, dists[name]))

    # Add neighbors for processing
    neighbor_names = map(lambda (name, dist): name, neighbors)
    nodes = nodes.union(neighbor_names)

  return dists

print(dijkstra(graph, 'd'))
