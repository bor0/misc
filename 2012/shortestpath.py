#                 2
#          #2# ------ #3#
#          /| `\       |
#       1/` |   `\4    |3
#      /`   |5    `\   |
#    #1#    |       `\ |
#          #5# ------ #4#
#                 6
G = {
1: [2],
2: [1,3,4,5],
3: [2,4],
4: [2,3,5],
5: [4,2]
}

nodes_and_prices = [
[2, 1, 1],
[1, 2, 1],
[3, 2, 2],
[2, 3, 2],
[4, 3, 3],
[3, 4, 3],
[4, 2, 4],
[2, 4, 4],
[4, 5, 6],
[5, 4, 6],
[2, 5, 5],
[5, 2, 5],
]

def find_lowest_price(pricelist):
	min = pricelist[0][1]
	tag = 0
	for i in pricelist:
		if i[1] < min:
			min, tag = i[1], i[0]
	return pricelist[tag]

def find_price(start, end):
	for i in nodes_and_prices:
		if i[0] == start and i[1] == end:
			return i[2]
	return 0

def find_prices(paths):

	L = []
	for i in range(0, len(paths)):
		s = 0
		for j in range(0, len(paths[i]) - 1):
			s = s + find_price(paths[i][j], paths[i][j+1])
		L.append([i, s])
	return L

def find_all_paths(graph, start, end, path=[]):
	path = path + [start]

	if start == end: return [path]
	if not start in graph: return []

	L = []

	for node in graph[start]:
		if node not in path:
			newpaths = find_all_paths(graph, node, end, path)
			for newpath in newpaths:
				L.append(newpath)

	return L

def analyzegraph(graph, start, end):
	print("Graph analysis, path: " + str(start) + " -> " + str(end))
	x = find_all_paths(graph, start, end)
	print("All paths: " + str(x))
	y = find_prices(x)
	print("Path indexes and their prices: " + str(y))
	z = find_lowest_price(y)
	print("Lowest price is: " + str(z))

	print("Lowest path per price is: " + str(x[z[0]]))

def find_shortest_path(graph, start, end, path=[]):
	path = path + [start]

	if start == end: return path
	if not start in graph: return None

	shortest = None

	for node in graph[start]:
		if node not in path:
			newpaths = find_shortest_path(graph, node, end, path)
			if newpaths:
				if not shortest or len(newpaths) < len(shortest):
					shortest = newpaths
	return shortest


#analyzegraph(G, 1, 4)
print(
find_shortest_path(G, 1, 4)
)