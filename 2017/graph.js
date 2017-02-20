// Graph implementation with basic operations

module.exports = function(vertices) {
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
			});
		}

		return [];
	};

	this.for_each = function(callback) {
		var keys = Object.keys(this.vs);
		keys.forEach(function (key) {
			callback(key, self.vs[key]);
		});
	}

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
