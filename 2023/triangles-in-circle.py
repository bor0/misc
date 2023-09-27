import math

# tiny proof that not all triangles whose points lie in a circle have the same length

# input these
points1 = [ 0.8, 0.6, 0.28 ]
points2 = [ 0.6, 0.07584, 0.5376 ]

## do not modify after this line ##

# given a two points in the form of {'x': ..., 'y': ...} calculate the distance
def distance(p1, p2):
  return math.sqrt( (p2['x'] - p1['x'])**2 + (p2['y'] - p1['y'])**2 )

# given a set of points {'x': ..., 'y': ...} calculate the sum of all consecutive distances
# e.g. sum(d(p1, p2), d(p2, p3), ..., d(p3, p1))
def calc_dist_sum(points):
  suma = 0
  for i in range(-1, len(points) - 1):
    suma += distance(points[i], points[i+1])

  return suma

# given a set of integers, convert them to format {'x': item, 'y': ...}
# where both x and y satisfy x^2 + y^2 = 1 (the positive part)
def mk_points(points):
  return list(map(lambda x: { 'x': x, 'y': math.sqrt(1 - x**2) }, points))

# useless wrapper
def calc(points):
  return calc_dist_sum(mk_points(points))

points1_calc = calc(points1)
points2_calc = calc(points2)

print("Checking equality", points1_calc, points2_calc)

if points1_calc == points2_calc:
  print("Wow, same length! But make sure to check other triangles as well; doesn't mean they all are")
else:
  print("Nope!")
