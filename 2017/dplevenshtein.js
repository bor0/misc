function levenshtein(str1, str2) {
	var memo = new Array(str1.length).fill(undefined);
	memo = memo.map(() => new Array(str2.length).fill(undefined));
	var count = 0;

	var ls = function ls(str1, str1index, str2, str2index) {
		count++;

		if (memo[str1index - 1] && memo[str1index - 1][str2index - 1]) {
			// already calculated
			return memo[str1index - 1][str2index - 1];
		}

		if (str1index == 0) return str2index;
		if (str2index == 0) return str1index;

		var add = str1[str1index - 1] == str2[str2index - 1] ? 0 : 1;

		return memo[str1index - 1][str2index - 1] = Math.min(
			1 + ls(str1, str1index - 1, str2, str2index), // add 1 char
			1 + ls(str1, str1index, str2, str2index - 1), // remove 1 char
			add + ls(str1, str1index - 1, str2, str2index - 1) // either equal or transform
		);
	}

	var ret = ls(str1, str1.length,
		str2, str2.length);

	console.log([memo, count]);

	return ret;
}

console.log(levenshtein('guest', 'test'));
