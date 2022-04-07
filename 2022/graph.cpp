// g++ graph.cpp -std=c++11
#include <iostream>
#include <vector>
#include <stack>
#include <queue>

using namespace std;
#define V 5

typedef vector<int> Graph;
 
Graph G[V];

void addEdge(Graph G[], int u, int v) {
	G[u].push_back(v);
	G[v].push_back(u);
}
 
void printGraph(Graph G[]) {
	for (int v = 0; v < V; ++v) {
		cout << "Teme " << v << ": ";
		for (auto x : G[v]) cout << x << ",";
		cout << endl;
	}
}
 
void DFS(Graph G[], int start) {
	stack<int> stack;
	stack.push(start);
	int visited[V] = { 0 };
	while (!stack.empty()) {
		int node = stack.top();
		cout << node << ",";
		stack.pop();
		if (visited[node]) continue;
		visited[node] = 1;
		for (auto next : G[node]) {
			if (visited[next] == 0) stack.push(next);
		}
	}
	cout << endl;
}

void BFS(Graph G[], int start) {
	queue<int> queue;
	queue.push(start);
	int visited[V] = { 0 };
	while (!queue.empty()) {
		int node = queue.front();
		cout << node << ",";
		queue.pop();
		if (visited[node]) continue;
		visited[node] = 1;
		for (auto next : G[node]) {
			if (visited[next] == 0) queue.push(next);
		}
	}
	cout << endl;
}

void Dijkstra(Graph G[], int start) {
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
		for (auto next : G[node]) {
			if (visited[next] == 0) queue.push(next);
			int cur = dists[node] + next;
			dists[next] = min(cur, dists[next]);
		}
	}

	for (int i = 0; i < V; i++) {
		cout << "Rastojanie od " << dists[start] << " do " << i << " iznesuva " << dists[i] << endl;
	}
}

int main() {
	addEdge(G, 0, 1);
	addEdge(G, 0, 4);
	addEdge(G, 1, 2);
	addEdge(G, 1, 3);
	addEdge(G, 1, 4);
	addEdge(G, 2, 3);
	addEdge(G, 3, 4);
	printGraph(G);
	cout << "DFS(G, 0) = ";
	DFS(G, 0);
	cout << "BFS(G, 0) = ";
	BFS(G, 0);
	Dijkstra(G, 0);
	return 0;
}
