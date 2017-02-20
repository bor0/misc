// Graph implementation with basic operations

var Graph = function(vertices) {
	var self = this;
	this.vs = {};

	this.adjacent = function(v1, v2) {
		return this.vs[v1] && this.vs[v1].e.some(function(v3) {
			return v3.k === v2;
		});
	};

	this.neighbors = function(v) {
		if (this.vs[v]) {
			return this.vs[v].e.map(function(v2) {
				return v2.k;
			});;
		}

		return [];
	};

	this.has_path = function(v1, v2) {
		var visited = [];
		return (function p(v1, v2) {
			var n = self.neighbors(v1);

			for (var i = 0; i < n.length; i++) {
				var v3 = n[i];

				if (v3 === v2) return true;
				if ( ! visited.includes(v3)) {
					visited.push(v3);
					if (p(v3, v2)) {
						return true;
					}
				}
			}

			return false;

		})(v1, v2);
	};

	this.add_vertex = function(v) {
		if (!this.vs[v]) {
			this.vs[v] = {
				e: [],
			};
		}
	};

	this.remove_vertex = function(v) {
		if (this.vs[v]) {
			this.vs[v].e.forEach(function (v2) {
				self.vs[v2.k].e = self.vs[v2.k].e.filter(function (v3) {
					return v3.k !== v;
				});
			});


			delete this.vs[v];
		}
	};

	this.add_edge = function(v1, v2) {
		if (this.vs[v1] && this.vs[v2] && ! this.adjacent(v1, v2)) {
			this.vs[v1].e.push({k: v2});
		}
	};

	this.remove_edge = function(v1, v2) {
		if (this.vs[v1] && this.vs[v2]) { 
			this.vs[v1].e = this.vs[v1].e.filter(function (v3) {
				return v3.k !== v2; 
			});
		}
	};

	this.get_vertex_value = function(v) {
		if (this.vs[v]) {
			return this.vs[v].val;
		}
		return undefined;
        };

        this.set_vertex_value = function(v, val) {
		if (this.vs[v]) {
			this.vs[v].val = val;
		}
        };

	this.set_edge_value = function(v1, v2, val) {
		if (this.vs[v1] && this.vs[v2]) {
			var obj = this.vs[v1].e.find(function (v3) {
				return v3.k === v2;
			});
			obj.v = val;
		}
	}

	this.get_edge_value = function(v1, v2) {
		if (this.vs[v1]) {
			var obj = this.vs[v1].e.find(function (v3) {
				return v3.k === v2;
			});

			if (obj) {
				return obj.v;
			}
		}
		return undefined;
	}

	vertices = vertices || [];

	if (vertices.constructor !== Array) {
		vertices = [vertices];
	}

	vertices.forEach(function(v) {
		self.add_vertex(v);
	});
};

var G = new Graph(['Skopje', 'Gostivar', 'Struga']);

G.add_vertex('Ohrid');

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
