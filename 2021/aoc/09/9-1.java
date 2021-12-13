/*
mv 9-1.java NineOne.java # cause Java
javac NineOne.java && java NineOne
mv NineOne.java 9-1.java
*/
import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

public class NineOne {
	protected static boolean boundsCheck(List<List<Integer>> matrix, int x, int y) {
		int height = matrix.size();
		int width = matrix.get(0).size();

		return 0 <= x && x < height && 0 <= y && y < width;
	}

	protected static List<Integer> getPositions(List<List<Integer>> matrix, int x, int y) {
		List<Integer> vals = new ArrayList<Integer>();

		if (boundsCheck(matrix, x - 1, y)) vals.add(matrix.get(x - 1).get(y));
		if (boundsCheck(matrix, x + 1, y)) vals.add(matrix.get(x + 1).get(y));
		if (boundsCheck(matrix, x, y - 1)) vals.add(matrix.get(x).get(y - 1));
		if (boundsCheck(matrix, x, y + 1)) vals.add(matrix.get(x).get(y + 1));

		return vals;
	}

	public static void main(String[] args) {
		List<List<Integer>> matrix = new ArrayList<List<Integer>>();
		try (BufferedReader br = new BufferedReader(new FileReader("input"))) {
			String line;
			while ((line = br.readLine()) != null) {
				List<Integer> res = line.chars().map(c -> c-'0').boxed().collect(Collectors.toList());
				matrix.add(res);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		int height = matrix.size();
		int width = matrix.get(0).size();

		int sum = 0;
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {
				List<Integer> sums = getPositions(matrix, i, j);
				int el = matrix.get(i).get(j);
				if (el < Collections.min(sums)) {
					sum += el + 1;
				}
			}
		}
		
		System.out.println(sum);
	}
}

