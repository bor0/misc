with open('input') as f:
  L = f.read().split('\n\n')
  points = L[0].split('\n')
  points = set(map(lambda x: (int(x.split(',')[0]), int(x.split(',')[1])), points))

  L[1] = L[1].replace('fold along ', '').replace('=','')
  actions = list(filter(lambda x: x, L[1].split('\n')))

def foldy(points_up, y):
  points_down = set([ p for p in points_up if p[1] > y ])
  points_up = points_up - points_down
  points_down = set([ (p[0], 2 * y - p[1]) for p in points_down if 2 * y - p[1] >= 0 ])

  return points_up.union(points_down)

def foldx(points_left, x):
  points_right = set([ p for p in points_left if p[0] > x ])
  points_left = points_left - points_right
  points_right = set([ (2 * x - p[0], p[1]) for p in points_right if 2 * x - p[0] >= 0 ])

  return points_left.union(points_right)

def render(points):
  max_x = max(map(lambda (x, y): x, points))
  max_y = max(map(lambda (x, y): y, points))

  for y in range(0, max_y+1):
    s = ''
    for x in range(0, max_x+1):
      if (x, y) in points: s = s + '#'
      else: s = s + '.'
    print(s)

for a in actions:
  if a[0] == 'x':
    points = foldx(points, int(a[1:]))
  else:
    points = foldy(points, int(a[1:]))

render(points)
