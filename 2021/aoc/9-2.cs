using System;

using System.Collections.Generic;
using System.Linq;

class NineTwo {
	protected static bool boundsCheck(List<List<int>> matrix, int x, int y) {
		int height = matrix.Count;
		int width = matrix[0].Count;

		return 0 <= x && x < height && 0 <= y && y < width;
	}

	protected static List<int> getPositions(List<List<int>> matrix, int x, int y) {
		var vals = new List<int>();

		if (boundsCheck(matrix, x - 1, y)) vals.Add(matrix[x - 1][y]);
		if (boundsCheck(matrix, x + 1, y)) vals.Add(matrix[x + 1][y]);
		if (boundsCheck(matrix, x, y - 1)) vals.Add(matrix[x][y - 1]);
		if (boundsCheck(matrix, x, y + 1)) vals.Add(matrix[x][y + 1]);

		return vals;
	}

	protected static List<Tuple<int, int>> populateLowPoints(List<List<int>> matrix) {
		int height = matrix.Count;
		int width = matrix[0].Count;

		List<Tuple<int, int>> lowPoints = new List<Tuple<int, int>>();
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				List<int> sums = getPositions(matrix, i, j);
				int el = matrix[i][j];
				if (el < sums.Min()) {
					lowPoints.Add(new Tuple<int, int>(i, j));
				}
			}
		}
		
		return lowPoints;
	}

	protected static HashSet<Tuple<int, int>> getCoordinates(List<List<int>> matrix, int x, int y) {
		var ret = new HashSet<Tuple<int, int>>();

		if (matrix[x][y] == 9) {
			return ret;
		}

		ret.Add(new Tuple<int, int>(x, y));

		if (boundsCheck(matrix, x-1, y) && matrix[x][y]+1 <= matrix[x-1][y]) ret.UnionWith(getCoordinates(matrix, x-1, y));
		if (boundsCheck(matrix, x+1, y) && matrix[x][y]+1 <= matrix[x+1][y]) ret.UnionWith(getCoordinates(matrix, x+1, y));
		if (boundsCheck(matrix, x, y-1) && matrix[x][y]+1 <= matrix[x][y-1]) ret.UnionWith(getCoordinates(matrix, x, y-1));
		if (boundsCheck(matrix, x, y+1) && matrix[x][y]+1 <= matrix[x][y+1]) ret.UnionWith(getCoordinates(matrix, x, y+1));

		return ret;
	}

	static void Main(string[] args) {
		var matrix = new List<List<int>>();
		var lines = System.IO.File.ReadAllLines(@"input");

		foreach (var line in lines) {
			var result = line.Select(ch => ch -'0').ToList();
			matrix.Add(result);
		}

		var lowPoints = populateLowPoints(matrix);
		var lengths = new List<int>();

		foreach (var point in lowPoints) {
			lengths.Add(getCoordinates(matrix, point.Item1, point.Item2).Count);
		}

		lengths.Sort();
		lengths.Reverse();
		int prod = 1;
		foreach (var length in lengths.Take(3)) {
			prod *= length;
		}

		Console.WriteLine(prod);
	}
}
