"""
Solution for http://www.nordeus.com/27a06a9e3d5e7f67eb604a39536208c9/

Boro Sitnikovski, 07.2013
"""

import sys


def getmap(file):

  map = {}
  file = open(file, 'r')

  for line in file:
    if line[0] == '*': break
    line = line.replace('\r\n', '\n').replace('\n', '').split(':')
    key = line[0]
    val = line[1].split(',')
    map[key] = val

  file.close()
  return map

def getfreecolor(coloredmap, neighbours):
  freecolor = 1
  busycolors = []

  for neighbour in neighbours:
    color = coloredmap.get(neighbour)
    if color != None and not color in busycolors:
      busycolors.append(color)

  busycolors = sorted(busycolors)

  for busycolor in busycolors:
    if freecolor == busycolor:
      freecolor = freecolor + 1
    else:
      break

  return freecolor

def colormap(map):

  coloredmap = {}
  stack = [map.keys()[0]]

  while len(stack) != 0:

    municipality = stack.pop()

    if coloredmap.get(municipality) != None:
      continue

    neighbours = map.get(municipality)
    freecolor = getfreecolor(coloredmap, neighbours)
    coloredmap[municipality] = freecolor

    for neighbour in neighbours:
      stack.append(neighbour)

  return coloredmap

map = getmap(sys.argv[1])
coloredmap = colormap(map)

for key, value in coloredmap.items():
  print key, value
