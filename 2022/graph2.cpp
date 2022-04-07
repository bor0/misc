#include <iostream>
#include <queue>

using namespace std;
 
#define V 5
typedef int Graph[V][V];
Graph G;

void FloydWarshall(Graph);
void Dijkstra(Graph, int);
void PrimMST(Graph, int);

void initGraph(Graph G) {
	for (int i = 0; i < V; i++) {
		for (int j = 0; j < V; j++) {
			G[i][j] = INT_MAX;
		}
	}
}

void addEdge(Graph G, int u, int v, int weight) {
	G[u][v] = G[v][u] = weight;
}

void printGraph(Graph G) {
	for (int i = 0; i < V; i++) {
		for (int j = 0; j < V; j++) {
			if (G[i][j] == INT_MAX)
				cout << "∞" << "\t";
			else
				cout << G[i][j] << "\t";
		}
		cout << endl;
	}
}

int main() {
	initGraph(G);
	addEdge(G, 0, 1, 1);
	addEdge(G, 0, 4, 2);
	addEdge(G, 1, 2, 3);
	addEdge(G, 1, 3, 4);
	addEdge(G, 1, 4, 5);
	addEdge(G, 2, 3, 6);
	addEdge(G, 3, 4, 7);
	printGraph(G);

	Dijkstra(G, 0);
	FloydWarshall(G);
	PrimMST(G, 0);
}

void FloydWarshall(Graph G) {
	Graph dists;
 
	for (int i = 0; i < V; i++)
		for (int j = 0; j < V; j++)
			dists[i][j] = G[i][j];

	for (int i = 0; i < V; i++)
		dists[i][i] = 0;
 
	for (int k = 0; k < V; k++) {
		for (int i = 0; i < V; i++) {
			for (int j = 0; j < V; j++) {
				if (dists[i][j] > (dists[i][k] + dists[k][j])
					&& (dists[k][j] != INT_MAX
						&& dists[i][k] != INT_MAX))
					dists[i][j] = dists[i][k] + dists[k][j];
			}
		}
	}

	printGraph(dists);
}

void Dijkstra(Graph G, int start) {
	int dists[V];
	for (int i = 0; i < V; i++) dists[i] = INT_MAX;
	dists[start] = 0;
	queue<int> queue;
	queue.push(start);
	int visited[V] = { 0 };
	while (!queue.empty()) {
		int node = queue.front();
		queue.pop();
		if (visited[node]) continue;
		visited[node] = 1;
		for (int next = 0; next < V; next++) {
			int weight = G[node][next];
			if (weight == INT_MAX) continue;

			if (visited[next] == 0) queue.push(next);
			dists[next] = min(dists[node] + weight, dists[next]);
		}
	}

	for (int i = 0; i < V; i++) {
		cout << "Rastojanie od " << dists[start] << " do " << i << " iznesuva " << dists[i] << endl;
	}
}

void PrimMST(Graph G, int start) {
	int visited[V] = { 0 };
	visited[start] = true;
	int x = 0, y = 0;

	cout << "Rebro\tTezina" << endl;

	for (int edge = 0; edge < V-1; edge++) {
		int min = INT_MAX;

		for (int i = 0; i < V; i++) {
			if (!visited[i]) continue;
			for (int j = 0; j < V; j++) {
				if (!visited[j] && G[i][j] && min > G[i][j]) {
					min = G[i][j]; x = i; y = j;
				}
			}
		}
		visited[y] = true;
		cout << x << "-" << y << "\t" << G[x][y] << endl;
	}
}
