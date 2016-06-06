class Vertex:
    def __init__(self, name):
        self.name = name
        self.neighbours = {}

    def add_neighbour(self, neighbour, distance):
        self.neighbours[neighbour.name] = (neighbour, distance)
        if not self.name in neighbour.neighbours:
            # ova go pravi Graph-ot undirected
            neighbour.add_neighbour(self, distance)

    def length(self, neighbour):
        if neighbour.name in self.neighbours:
            return self.neighbours[neighbour.name][1]
        else:
            # Infinity
            return 100000

# dobar za directed graph, distance pomegju site parovi
"""
The Floyd–Warshall algorithm compares all possible paths through the graph between each pair of vertices. It is able
to do this with Θ(|V|^3) comparisons in a graph. This is remarkable considering that there may be up to Ω(|V|^2) edges
in the graph, and every combination of edges is tested. It does so by incrementally improving an estimate on the
shortest path between two vertices, until the estimate is optimal.

Consider a graph G with vertices V numbered 1 through N. Further consider a function shortestPath(i, j, k) that
returns the shortest possible path from i to j using vertices only from the set {1,2,...,k} as intermediate points
along the way. Now, given this function, our goal is to find the shortest path from each i to each j using only
vertices 1 to k + 1.

For each of these pairs of vertices, the true shortest path could be either

(1) a path that only uses vertices in the set {1, ..., k}
or
(2) a path that goes from i to k + 1 and then from k + 1 to j.

We know that the best path from i to j that only uses vertices 1 through k is defined by shortestPath(i, j, k),
and it is clear that if there were a better path from i to k + 1 to j, then the length of this path would be the
concatenation of the shortest path from i to k + 1 (using vertices in {1, ..., k}) and the shortest path from
{k + 1} to j (also using vertices in {1, ..., k}).

If w(i, j) is the weight of the edge between vertices i and j, we can define shortestPath(i, j, k + 1) in terms of
the following recursive formula:

the base case is
shortestPath(i, j, 0) = w(i, j)
and the recursive case is
shortestPath(i,j,k+1) = min(shortestPath(i,j,k), shortestPath(i,k+1,k) + shortestPath(k+1,j,k))
"""
def shortestPath(Graph, i, j, k):
    if k == 0:
        return Graph[i].length(Graph[j])

    return min([shortestPath(Graph, i, j, k - 1), shortestPath(Graph, i, k, k - 1) + shortestPath(Graph, k, j, k - 1)])

def FloydWarshall(Graph):
    dist = {}

    for v in Graph:
        dist[v.name] = {v.name: 0}

    for i in Graph:
        for j in Graph:
            dist[i.name][j.name] = i.length(j)

    for k in Graph:
        for i in Graph:
            for j in Graph:
                if dist[i.name][j.name] > dist[i.name][k.name] + dist[k.name][j.name]:
                    dist[i.name][j.name] = dist[i.name][k.name] + dist[k.name][j.name]

    return dist

# najdobra kompleksnost za undirected graph, single source
def Dijkstra(Graph, source, debug = False):
    def find_by_least_distance(Q, dist):
        minimum, vertex = dist[Q[0].name], Q[0]

        for i in Q:
            if dist[i.name] < minimum:
                minimum, vertex = dist[i.name], i

        Q.remove(vertex)

        return vertex

    Q = []
    dist = {}
    prev = {}
    iteracija = 1

    for v in Graph:
        dist[v.name], prev[v.name] = 10000, None
        Q.append(v)

    dist[source.name], prev[source.name] = 0, source

    while Q:
        u = find_by_least_distance(Q, dist)

        if debug:
            if iteracija == 1:
                print("1. Prva iteracija (bidejki source = u), u = " + u.name + ":")
            else:
                print("\n" + str(iteracija) + ". Nova iteracija, u = " + u.name + ":")

            iteracija += 1

            neighbours = []

            for key, (v, _) in u.neighbours.iteritems():
                neighbours.append(v.name)

            print("Najden po minimum dist " + str(dist[u.name]))
            print("neighbours = " + str(neighbours))

        for key, (v, _) in u.neighbours.iteritems():
            alt = dist[u.name] + u.length(v)
            if debug:
                print("  v = " + v.name + ":")
                print("    alt = dist[" + u.name + "] + " + u.name + ".length(" + v.name + ") = " + str(dist[u.name]) + " + " + str(u.length(v)) + " = " + str(alt))
            if alt < dist[v.name]:
                if debug:
                    print("    alt < " + v.name + " => " + str(alt) + " < " + str(dist[v.name]) + " => " + v.name + ".distprev = " + str((alt, u.name)))
                dist[v.name], prev[v.name] = alt, u
            elif debug:
                print("    not alt < " + v.name + " => not " + str(alt) + " < " + str(dist[v.name]))

    return (dist, prev)


vl = Vertex("Vlae")
il = Vertex("Ilindenska")
pa = Vertex("Partizanska")
ce = Vertex("Centar")
kv = Vertex("Kisela Voda")

vl.add_neighbour(il, 5)
vl.add_neighbour(pa, 6)

il.add_neighbour(ce, 10)

pa.add_neighbour(ce, 5)

kv.add_neighbour(ce, 3)

Graph = [vl, il, pa, ce, kv]

print("=======\nFloyd Warshall\n=======")
dist = FloydWarshall(Graph)
for key in dist:
    print(key, dist[key])

print("Recursive Floyd Warshall, distance between 0th and 3rd index: ", shortestPath(Graph, 0, 3, 4))

print("=======\nDijkstra\n=======")
intro = """dist i prev se apsolutni vrednosti, mozno e da se updejtiraat pri sekoja iteracija

  partizanska
 6/        5\\
vlae      centar
 5\\       10/
  ilindenska
"""

print(intro)
dist, prev = Dijkstra(Graph, vl)

print("")

for key in dist:
    print(key, dist[key], prev[key].name)
