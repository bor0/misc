var Graph = require('./graph.js');

function vertexOfMinVal(dist, q) {
	var minVal = dist[q[0]];
	var u = q[0];

	Object.keys(dist).forEach(function (v) {
		if (dist[v] < minVal && q.includes(v)) {
			minVal = dist[v]; u = v;
		}
	});

	return u;
}

function dijkstra(Graph, v_source, v_target) {
	var q = [];
	var dist = {};
	var prev = {};

	Graph.for_each(function(v) {
		// Unknown distance and path from source to v
		dist[v] = prev[v] = Infinity;

		// All nodes initially in Q (unvisited nodes)
		q.push(v);
	});

	// Distance from source to source
	dist[v_source] = 0;

	while (q.length) {
		// Node with the least distance will be selected first
		var u = vertexOfMinVal(dist, q);

		// Remove v from q
		q = q.filter(function(v) {
			return v !== u;
		});

		Graph.neighbors(u).forEach(function(v) {
			var alt = dist[u] + Graph.get_edge_value(u, v);

			// A shorter path to v has been found
			if (alt < dist[v]) {
				dist[v] = alt;
				prev[v] = u;
			}
		});
	}

	return [dist, prev];
}

var G = new Graph(['1', '2', '3', '4', '5', '6']);

var edges = [
	['1', '2', 7 ], ['1', '3', 9 ], ['1', '6', 14],
	['2', '3', 10], ['2', '4', 15],
	['3', '6', 2 ], ['3', '4', 11],
	['4', '5', 5 ],
	['5', '6', 9 ]
];

edges.forEach(function (value) {
	G.add_edge(value[0], value[1]);
	G.set_edge_value(value[0], value[1], value[2]);

	G.add_edge(value[1], value[0]);
	G.set_edge_value(value[1], value[0], value[2]);
});

console.log(dijkstra(G, '1'));
