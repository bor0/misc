// for Manasa and Stones from HackerRank
function mktree(depth, index, a, b) {
	var tree = { v: index, r: null, l: null };

	if (depth == 0) {
		return tree;
	}

	tree.r = mktree(depth - 1, index + a, a, b);
	tree.l = mktree(depth - 1, index + b, a, b);

	return tree;
}

function mktree2(depth, index, a, b) {
	var arr = [];

	if (depth == 0) {
		return index;
	}

	arr = arr.concat( mktree2(depth - 1, index + a, a, b) );
	arr = arr.concat( mktree2(depth - 1, index + b, a, b) );

	return arr;
}

// the solution won't work because 1 <= n,a,b <= 10^3, and since the complexity is 2^n, we get 2^1000 which is too big.
// but it was interesting to write it

/*

     0
    / \
   /   \
  1     2
 / \   / \
2   3 3   4

*/
