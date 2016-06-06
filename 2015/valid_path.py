paths = [
    ('1', '2'),
    ('2', '3')
]

def tc(points):
  points = set(points)
  newpoints = None

  while newpoints != points:
    newpoints = set(points)
        
    for i in newpoints:
      for j in newpoints:
        if i != j and i[1] == j[0]:
          newpoint = (i[0], j[1])
          if not newpoint in newpoints:
            points |= set([(i[0], j[1])])

    return points

def transitive_closure(a):
    closure = set(a)
    while True:
        new_relations = set((x,w) for x,y in closure for q,w in closure if q == y)

        closure_until_now = closure | new_relations

        if closure_until_now == closure:
            break

        closure = closure_until_now

    return closure

def valid_path(paths, a, b):
    if a == b:
        return True

    for p in paths:
        if p[0] == a:
            newpaths = filter(lambda x: x != p, paths)
            if valid_path(newpaths, p[0], b) or valid_path(newpaths, p[1], b):
                return True

    return False

def valid_path2(paths, a, b):
    paths = tc(paths)

    if (a, b) in paths:
        return True

    return False

print(valid_path(paths, '1', '3'))
print(tc(paths))
print(transitive_closure(paths))
print(valid_path2(paths, '1', '3'))
