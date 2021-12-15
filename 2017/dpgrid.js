var mat = [
	[ 1, 2, 3 ],
	[ 4, 5, 6 ],
	[ 7, 8, 9 ]
];

function calc(mat, i, j) {
	if (i == 0 && j == 0) {
		return mat[0][0];
	}
	if (i == 0) {
			return mat[i][j] + calc(mat, i, j - 1);
	}
	if (j == 0) {
		return mat[i][j] + calc(mat, i - 1, j);
	}

	return mat[i][j] + Math.min(
		calc(mat, i - 1, j),
		calc(mat, i, j - 1));
}

console.log(calc(mat, 2, 2));
