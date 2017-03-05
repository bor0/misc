function create_balanced_bst(array) {
	array.sort();

	return function create_tree(array) {

		if (array.length <= 1) {
			return { v: array.pop() };
		}

		const mid = (array.length + 1)/ 2;

		const left = array.slice(mid);
		var right = array.slice(0, mid);
		const value = right.pop();

		return {
			v: value,
			l: create_tree(left),
			r: create_tree(right),
		};
	}(array);
}


console.log(create_balanced_bst([1,2,3,4,5,6,7]));
console.log(create_balanced_bst([1,2,3,4,5,6]));
console.log(create_balanced_bst([1,2]));
console.log(create_balanced_bst([1]));
