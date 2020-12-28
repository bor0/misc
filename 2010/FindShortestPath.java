import java.util.ArrayList;
import java.util.List;

public class FindShortestPath {

	public static class pathFinder {
		boolean init = false, debug = false;
		String minsteps = "";
		char [][]map;
		int size, maxdepth;
		List<Character> move = new ArrayList<Character>();

		public void findPath(int x, int y, String steps, int depth) {
			if (x < 0 || y < 0 || x >= map[0].length || y >= map[0].length || depth >= maxdepth) return;
			if (map[x][y] == '#') return;
			if (map[x][y] == 'X') {
				if (steps.length() < minsteps.length() || init == false) minsteps = steps;
				init = true;
				if (debug) System.out.println("Found path " + steps + "; depth level = " + depth);
				return;
			}

			if (move.contains('n')) findPath(x, y+1, steps+"R", depth+1);
			if (move.contains('e')) findPath(x+1, y, steps+"U", depth+1);
			if (move.contains('w')) findPath(x-1, y, steps+"D", depth+1);
			if (move.contains('s')) findPath(x, y-1, steps+"L", depth+1);
			return;
		}
			
		public pathFinder(String[] map, String move, int depth) {
			int tmpi=-1, tmpj=-1;
			boolean xfound = false;
			size = map.length;
			this.map = new char[size][size];
			int j = size-1;
			for (String i:map) {
				for (int k=0;k<size;k++) {
					this.map[j][k] = i.charAt(k);
					if (i.charAt(k) == '1') {
						tmpi = j; tmpj = k;
					} else if (i.charAt(k) == 'X') {
						if (xfound) throw new NullPointerException("Double X found");
						xfound = true;
					}
				}
				j--;
			}
			for (int i=0;i<move.length();i++) this.move.add(move.charAt(i));
			maxdepth = depth;
			if (tmpi == -1 || xfound == false) throw new NullPointerException("Starting point or end point not found");
			printMap();
			findPath(tmpi, tmpj, "", 0);
			if (init == false) System.out.println("Can't find any path for the given depth " + maxdepth);
			else System.out.println(minsteps);
		}
		
		public void toggleDebug() {
			debug=!debug;
		}
		
		/*public pathFinder() throws Exception {
			throw new RuntimeException("Exception in constructor");
		}*/

		public void printMap() {
			for (int j=size-1;j>=0;j--) System.out.println(map[j]);
		}
	}

	public static void main(String[] args) {
		String[] org = new String[]{
		"1#000",
		"0#0#0",
		"0#0#0",
		"0#0#0",
		"000#X"
		};
		
		try {
			pathFinder t = new pathFinder(org, "news", 21);
		}
		catch(Exception e) {}

		return;
	}
}