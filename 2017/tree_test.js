var dfstree = {
    v: 1,
    l: {
        v: 2,
        l: {
            v: 3,
            l: { v: 4 },
            r: { v: 5 },
        },
        r: { v: 6 },
    },
    r: {
        v: 7,
        l: {
            v: 8,
            l: { v: 9 },
            r: { v: 10 },
        },
        r: { v: 11 },
    }
};

var bfstree = {
    v: 1,
    l: {
        v: 2,
        l: {
            v: 4,
            l: { v: 8 },
            r: { v: 9 },
        },
        r: { v: 5 },
    },
    r: {
        v: 3,
        l: {
            v: 6,
            l: { v: 10 },
            r: { v: 11 },
        },
        r: { v: 7 },
    }
};

var tree = require('./tree.js');

var treeFn = (function(arr) {
    return function(x) {
        arr.push(x.v);
    };
});

var dfsarray = [];
tree.dfs(dfstree, treeFn(dfsarray));
var bfsarray = [];
tree.bfs(bfstree, treeFn(bfsarray));
var assert = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

function compareArrays(a1, a2) {
    return a1.length==a2.length &&
    a1.every(function(v,i) { return v === a2[i]});
}

console.log(compareArrays(assert, dfsarray));
console.log(compareArrays(assert, bfsarray));
