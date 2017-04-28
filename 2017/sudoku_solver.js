function checkSudoku(m) {
	var checkbox = function(x, y) {
		var numbers = {};
		for (var i = x; i < x + 3; i++) {
			for (var j = y; j < y + 3; j++) {
				if (m[i][j]) {
					if (numbers[m[i][j]]) return false;
					numbers[m[i][j]] = true;
				}
			}
		}

		return true;
	}

	// check rows and cols
	for (var i = 0; i < 9; i++) {
		var orows = {};
		var ocols = {};
		for (var j = 0; j < 9; j++) {
			if (m[i][j]) {
				if (orows[m[i][j]]) return false;
				orows[m[i][j]] = true;
			}
			if (m[j][i]) {
				if (ocols[m[j][i]]) return false;
				ocols[m[j][i]] = true;
			}
		}
	}

	return checkbox(0, 0) && checkbox(0, 3) && checkbox(0, 6)
	&&  checkbox(3, 0) && checkbox(3, 3) && checkbox(3, 6)
	&&  checkbox(6, 0) && checkbox(6, 3) && checkbox(6, 6);
}

function solveSudoku(m) {
	m = m.slice().map( (x) => x.slice() );

	for (var i = 0; i < 9; i++) {
		for (var j = 0; j < 9; j++) {

			if (m[i][j] == undefined) {
				for (var k = 1; k <= 9; k++) {
					m[i][j] = k;
					var ret = solveSudoku(m);
					if (ret) return ret;
				}
			}
		}
	}

	if (checkSudoku(m)) {
		return m;
	} else {
		return false;
	}
}

var sudoku_correct =
	[[8,3,5,4,1,6,9,2,7],
	[2,9,6,8,5,7,4,3,1],
	[4,1,7,2,9,3,6,5,8],
	[5,6,9,1,3,4,7,8,2],
	[1,2,3,6,7,8,5,4,9],
	[7,4,8,5,2,9,1,6,3],
	[6,5,2,7,8,1,3,9,4],
	[9,8,1,3,4,5,2,7,6],
	[3,7,4,9,6,2,8,1,5]];

var sudoku_incorrect =
	[[8,3,5,4,1,6,9,2,7],
	[2,9,6,8,5,7,4,3,1],
	[4,1,7,2,9,3,6,5,8],
	[5,6,9,1,3,4,7,8,2],
	[1,2,3,6,7,8,5,4,9],
	[7,4,8,5,2,9,1,6,3],
	[6,5,2,7,8,1,3,9,4],
	[9,8,1,3,4,5,2,7,6],
	[3,7,4,9,6,2,8,1,1]];

var sudoku_partial =
	[[8,3,5,4,1,6,9,2,7],
	[2,,6,8,5,7,4,3,1],
	[4,1,7,2,9,3,6,5,8],
	[5,6,9,1,3,4,7,8,],
	[1,2,3,6,7,8,5,4,9],
	[7,4,8,5,2,9,1,6,3],
	[6,5,2,7,8,1,3,9,4],
	[9,8,1,3,4,5,2,7,6],
	[3,7,4,9,6,2,8,1,]];

console.log(checkSudoku(sudoku_correct));
console.log(checkSudoku(sudoku_incorrect));
console.log(solveSudoku(sudoku_partial));

var empty_sudoku = [0,0,0,0,0,0,0,0,0];
empty_sudoku = empty_sudoku.map( (x) => new Array(9) );
console.log(empty_sudoku);
console.log(solveSudoku(empty_sudoku));
