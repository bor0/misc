var tree = {};

tree.dfs = function(tree, fn) {
    // Stack/LIFO
    S = [tree];

    while (S.length) {
        var v = S.pop();

        fn(v);

        if (v.r) S.push(v.r);
        if (v.l) S.push(v.l);
    }
};

tree.bfs = function bfs(tree, fn) {
    // Queue/FIFO
    S = [tree];

    while (S.length) {
        var v = S.shift();

        fn(v);

        if (v.l) S.push(v.l);
        if (v.r) S.push(v.r);
    }
};

module.exports = tree;
