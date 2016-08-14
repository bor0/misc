var tree = {
    v: 5,
    l: {
        v: 3,
        l: {
            v: 2,
        },
        r: {
            v: 4,
        },
    },
    r: {
        v: 7,
        l: {
            v: 6,
        },
        r: {
            v: 8,
        },
    },
};

function invertTree(tree) {
    if (!tree.l || !tree.r) {
        return;
    }

    var tmp = tree.l;
    tree.l = tree.r;
    tree.r = tmp;

    invertTree(tree.l);
    invertTree(tree.r);
}

console.log(tree);
invertTree(tree);
console.log(tree);
