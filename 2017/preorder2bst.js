function preorder2bst(list) {
	if (list.length == 0) return null;
	var tree = {
		v: list[0],
		r: null,
		l: null,
	};
	var maxIndex = 0; // first max
	var minIndex = 0; // first min
	var max = list[0];
	var min = list[0];
	for (var i = 1; i < list.length; i++) {
		if (list[i] > max && maxIndex == 0) {
			max = list[i];
			maxIndex = i;
		} else if (list[i] < min && minIndex == 0) {
			min = list[i];
			minIndex = i;
		}
	}

	if (minIndex)
	tree.l = preorder2bst(list.slice(1, 1 + Math.abs(maxIndex - minIndex)));
	if (maxIndex)
	tree.r = preorder2bst(list.slice(maxIndex));
	return tree;
}

function bst2preorder(tree, arr) {
	arr = arr || [];
	if (!tree) {
		return arr;
	}

	arr.push(tree.v);
	arr = bst2preorder(tree.l, arr);
	arr = bst2preorder(tree.r, arr);

	return arr;
}

function validbst(list) {
	var tree = preorder2bst(list);
	var list2 = bst2preorder(tree);
	for (var i = 0; i < list.length; i++) {
		if (list[i] != list2[i]) {
			return false;
		}
	}
	return true;
}

console.log(validbst([1,2,3]));
console.log(validbst([2,1,3]));
console.log(validbst([3,2,1,5,4,6]));



console.log(validbst([1,3,4,2]));
console.log(validbst([3,4,5,1,2]));
