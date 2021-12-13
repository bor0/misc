with open('input') as f:
  L = f.read().split('\n')
  L = list(filter(lambda x: x, L)) # empty elements
  L = map(lambda x: x.split('-'), L)
  d = {}
  for [k, v] in L:
    if k in d: d[k].append(v)
    else: d[k] = [v]

    if v in d: d[v].append(k)
    else: d[v] = [k]

  L = d

def any_node_twice(path):
  # Find the traverse count of all nodes that were crossed more than once
  d = [ path.count(x) for x in set(path) if x.islower() and path.count(x) > 1 ]

  # If there are two nodes
  return sum(d) > 2

def traverse(tree, name = 'start'):
  acc = set()

  def go(tree, name, path = []):
    if name not in tree or any_node_twice(path): return
  
    for node in tree[name]:
      if node == 'start': continue

      if node == 'end': acc.add(','.join(['start'] + path + ['end']))
      else: go(tree, node, path + [node])

  go(tree, name)
  return acc

print(len(traverse(L)))
