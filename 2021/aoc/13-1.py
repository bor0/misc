with open('input') as f:
  L = f.read().split('\n\n')
  coords = L[0].split('\n')
  coords = set(map(lambda x: (int(x.split(',')[0]), int(x.split(',')[1])), coords))

  L[1] = L[1].replace('fold along ', '').replace('=','')
  actions = list(filter(lambda x: x, L[1].split('\n')))

def foldy(coords_up, y):
  coords_down = set([ p for p in coords_up if p[1] > y ])
  coords_up = coords_up - coords_down
  coords_down = set([ (p[0], 2 * y - p[1]) for p in coords_down if 2 * y - p[1] >= 0 ])

  return coords_up.union(coords_down)

def foldx(coords_left, x):
  coords_right = set([ p for p in coords_left if p[0] > x ])
  coords_left = coords_left - coords_right
  coords_right = set([ (2 * x - p[0], p[1]) for p in coords_right if 2 * x - p[0] >= 0 ])

  return coords_left.union(coords_right)

def printaj(coords):
  max_x = max(map(lambda (x, y): x, coords))
  max_y = max(map(lambda (x, y): y, coords))

  for j in range(0, max_y+1):
    s = ''
    for i in range(0, max_x+1):
      if (i,j) in coords: s = s + '#'
      else: s = s + '.'
    print(s)

actions = [ actions[0] ]

for a in actions:
  if a[0] == 'x':
    coords = foldx(coords, int(a[1:]))
  else:
    coords = foldy(coords, int(a[1:]))

print(len(coords))
