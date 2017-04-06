/* Rat in a maze algorithm */
var maze = [
	[1, 0, 0, 0],
	[1, 1, 0, 1],
	[0, 1, 0, 0],
	[1, 1, 1, 1]
]

function arraysEqual(a1,a2) {
    /* WARNING: arrays must not contain {objects} or behavior may be undefined */
    return JSON.stringify(a1)==JSON.stringify(a2);
}

function findPath(maze, src, dst) {
	var solution = [];

	function findPathRecur(maze, src, dst) {
		let lenX = maze.length, lenY = maze[0].length,
		srcX = src[0], srcY = src[1],
		dstX = dst[0], dstY = dst[1];

		/* we already checked this point */
		if (solution.find(x => arraysEqual(src, x))) return false;

		/* reached our destination */
		if (arraysEqual(src, dst)) return true;

		/* out of bounds */
		if (srcX >= lenX || srcX < 0 || srcY >= lenY || srcY < 0) return false;

		/* wall */
		if (maze[srcY][srcX] != 1) return false;

		/* assume this is a valid solution */
		solution.push(src);

		if (findPathRecur(maze, [srcX, srcY + 1], dst)) return true;
		if (findPathRecur(maze, [srcX, srcY - 1], dst)) return true;
		if (findPathRecur(maze, [srcX + 1, srcY], dst)) return true;
		if (findPathRecur(maze, [srcX - 1, srcY], dst)) return true;

		/* none of the above produced a solution, so backtrack (i.e. unmark src as a valid solution) */
		solution.pop();

		return false;
	}

	return findPathRecur(maze, src, dst) ? solution : false;
}

console.log(findPath(maze, [0, 0], [3, 3]));
