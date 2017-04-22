// merge two sorted arrays into a third sorted one
function merge(arr1, arr2, comp) {
	comp = comp || ((a, b) => a > b);
	var ret = [];

	while (arr1.length && arr2.length) {
		if (comp(arr1[0], arr2[0])) {
			ret.push(arr2.shift());
		} else {
			ret.push(arr1.shift());
		}
	}

	while (arr1.length) ret.push(arr1.shift());
	while (arr2.length) ret.push(arr2.shift());

	return ret;
}

// recursively merge halves
function mergesort(arr, comp) {
	if (arr.length <= 1) {
		return arr;
	}

	var half = arr.length / 2;

	return merge(
		mergesort(arr.slice(0, half), comp),
		mergesort(arr.slice(half), comp), comp
	);
}

console.log(merge([1,3,7,9], [4,5,7,11]));
console.log(mergesort([2,1,3,2,3,4,5,4]));
console.log(mergesort([2,1,3,2,3,4,5,4], (a, b) => a < b));
