var Graph = require('./graph.js');

var G = new Graph(['Skopje', 'Gostivar', 'Struga']);

G.add_vertex('Ohrid');

G.for_each(function(k, v) {
	console.log('vertice: ' + k + ',' + JSON.stringify(v));
});

G.add_edge('Skopje', 'Gostivar');
G.add_edge('Gostivar', 'Skopje');
G.add_edge('Gostivar', 'Ohrid');
G.add_edge('Ohrid', 'Gostivar');

console.log('Path test #1 ' + G.has_path('Skopje', 'Ohrid'));
console.log('Path test #2 ' + G.has_path('Skopje', 'Struga'));
G.add_edge('Ohrid', 'Struga');
console.log('Path test #3 ' + G.has_path('Skopje', 'Struga'));

G.set_edge_value('Skopje', 'Gostivar', 'test');
console.log('Edgeval test #1 ' + G.get_edge_value('Skopje', 'Gostivar'));
console.log('Edgeval test #2 ' + G.get_edge_value('Gostivar', 'Skopje'));

console.log('Neighbors test #1 ' + G.neighbors('Gostivar'));

console.log('Adjacency test #1 ' + G.adjacent('Skopje', 'Gostivar'));
console.log('Adjacency test #2 ' + G.adjacent('Skopje', 'Ohrid'));
console.log('Adjacency test #3 ' + G.adjacent('Ohrid', 'Gostivar'));

G.remove_edge('Gostivar', 'Ohrid');

console.log('Neighbors test #2 ' + G.neighbors('Gostivar'));

console.log('Adjacency test #4 ' + G.adjacent('Ohrid', 'Gostivar'));

G.set_vertex_value('Skopje', 10);
console.log('Vertex value test #1: ' + G.get_vertex_value('Skopje'));

G.remove_vertex('Skopje');
console.log('Vertex value test #2: ' + G.get_vertex_value('Skopje'));
