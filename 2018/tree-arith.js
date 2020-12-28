'use strict';
var underscore = require('underscore');

var TreeArith = underscore.noop;

underscore.extend(TreeArith.prototype, {
    mkTree: function (value, left, right) {
        var tree = {};

        if (!underscore.isUndefined(value)) {
            tree.v = underscore.clone(value);
        }

        if (!underscore.isUndefined(left)) {
            tree.l = underscore.clone(left);
        }

        if (!underscore.isUndefined(right)) {
            tree.r = underscore.clone(right);
        }

        return tree;
    },

    add: function (tree1, tree2) {
        var v, l, r;

        if (underscore.isEmpty(tree1) || underscore.isEmpty(tree2)) {
            // If either of the trees are empty, try to use the non-empty one.
            if (!underscore.isEmpty(tree1)) {
                return underscore.clone(tree1);
            }

            return underscore.clone(tree2);
        }

        // If value mismatch, tree1 has precedence over it in case both have a value defined.
        if (!underscore.isEqual(tree1.v, tree2.v)) {
            if (tree1.hasOwnProperty('v')) {
                v = tree1.v;
            } else {
                v = tree2.v;
            }
        } else {
            // Same value.
            v = tree1.v;
        }

        // If left leaf (sub-tree) mismatch, recursively calculate the merge.
        if (!underscore.isEqual(tree1.l, tree2.l)) {
            l = this.add(tree1.l, tree2.l);
        } else {
            // Same left leaf.
            l = tree1.l;
        }

        // If right leaf (sub-tree) mismatch, recursively calculate the merge.
        if (!underscore.isEqual(tree1.r, tree2.r)) {
            r = this.add(tree1.r, tree2.r);
        } else {
            // Same right leaf.
            r = tree1.r;
        }

        return this.mkTree(v, l, r);
    },

    sub: function (tree1, tree2) {
        var v, l, r;

        if (underscore.isEmpty(tree1) || underscore.isEmpty(tree2)) {
            // If either of the trees are empty, try to use the non-empty one.
            if (!underscore.isEmpty(tree2)) {
                return underscore.clone(tree2);
            }

            return underscore.clone(tree1);
        }

        // If value mismatch, tree1 has precedence over it.
        // We don't have an else case here since the diff is empty if values are the same.
        if (!underscore.isEqual(tree1.v, tree2.v)) {
            if (tree1.hasOwnProperty('v')) {
                v = tree1.v;
            } else {
                v = tree2.v;
            }
        }

        // If left leaf (sub-tree) mismatch, recursively calculate the diff.
        // We don't have an else case here since the diff is empty if values are the same.
        if (!underscore.isEqual(tree1.l, tree2.l)) {
            if (tree1.hasOwnProperty('l') && tree2.hasOwnProperty('l')) {
                l = this.sub(tree1.l, tree2.l);
            } else if (tree2.hasOwnProperty('l')) {
                l = tree2.l;
            } else {
                l = tree1.l;
            }
        }

        // If right leaf (sub-tree) mismatch, recursively calculate the diff.
        // We don't have an else case here since the diff is empty if values are the same.
        if (!underscore.isEqual(tree1.r, tree2.r)) {
            if (tree1.hasOwnProperty('r') && tree2.hasOwnProperty('r')) {
                r = this.sub(tree1.r, tree2.r);
            } else if (tree2.hasOwnProperty('r')) {
                r = tree2.r;
            } else {
                r = tree1.r;
            }
        }

        return this.mkTree(v, l, r);
    },
});

module.exports.TreeArith = TreeArith;
