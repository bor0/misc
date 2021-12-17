from queue import PriorityQueue

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
  nodes = PriorityQueue()
  nodes.put((0, start_node))
  processed = set()

  # Initialize distances
  # Default to infinity from start_node to each
  dists = {v : float('inf') for v in graph.keys()}
  dists[start_node] = 0

  while not nodes.empty():
    # Check the node hasn't been processed yet
    (_, node) = nodes.get()

    if node in processed: continue
    processed.add(node)

    # Get neighbors
    neighbors = graph[node]

    for (name, value) in neighbors:
      cur = dists[node] + value
      old = dists[name]
      # Check and set if it's smaller than the current minimum
      if cur < old:
        dists[name] = cur
        # Add neighbors for processing
        nodes.put((cur, name))
      print("Distance from %s to %s is %d" % (node, name, dists[name]))

  return dists

print(dijkstra(graph, 'd'))
