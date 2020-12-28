public class SumOfPowers {

	int rotations[][] = {
		{0},			// 0
		{1},			// 1
		{2, 4, 8, 6},		// 2
		{3, 9, 7, 1},		// 3
		{4, 6},			// 4
		{5},			// 5
		{6},			// 6
		{7, 9, 3, 1},		// 7
		{8, 4, 2, 6},		// 8
		{9, 1}			// 9
	};

	public int lastDigit(int N) {
		int p = 0;
		for (int i=1;i<=N;i++) {
			int t = (i+1)%(rotations[i%10].length);
			if (t == 0) t = rotations[i%10].length;
			t--;
			p += rotations[i%10][t];
		}
		return p%10;
	}

	/*public static void main(String[] args) {
		SumOfPowers t = new SumOfPowers();
		t.lastDigit(1);
	}*/
}