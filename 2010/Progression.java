public class Progression {
	
	int y[], x[];

	void calc(int pos) {
		y[pos] = (y[pos - 1] + y[pos + 1]) / 2;
	}

	void calc2(int pos) {
		x[pos] = (x[pos - 1] + x[pos + 1]) / 2;
	}
	
	boolean checkForValidProgression(int []progression) {
		int d = progression[1] - progression[0];
		for (int i=0;i<progression.length-1;i++) if ((progression[i+1] - progression[i] != d) || progression[i] < 1) return false;
		return true;
	}

	public int reverse(int[] progression) {
		int i, j;
		int sum[] = new int[2];
		x = progression.clone();
		y = progression.clone();
		int M = progression.length;

		for (i = 2; i < M-1; i += 2) {
			calc(i);
			// printf("%d: %d\n ", i, y[i]);
		}

		for (i = 1; i < M-1; i += 2) {
			calc2(i);
			// printf("%d: %d\n ", i, y[i]);
		}
		y[0] = y[1] - (y[2] - y[1]);
		x[0] = x[1] - (x[2] - x[1]);
		--M;
		x[M] = x[M-1] - (x[M-2] - x[M-1]);
		y[M] = y[M-1] - (y[M-2] - y[M-1]);
		++M;
		System.out.println("case 1: \n");
		for (i = 0, sum[0] = 0; i < M; i++) {
			System.out.println(y[i]);
			sum[0] += y[i];
		}
		System.out.println("case 1: sum " + sum[0] + "\n");
		for (i = 0, sum[1] = 0; i < M; i++) {
			System.out.println(x[i]);
			sum[1] += x[i];
		}
		System.out.println("case 2: sum " + sum[1] + "\n");
		if (checkForValidProgression(x) && checkForValidProgression(y))  {
			if (sum[0] < sum[1]) return sum[0];
			else return sum[1];
		}

		if (checkForValidProgression(y)) return sum[0];
		else return sum[1];
	}

	public static void main(String[] args) {
		Progression x = new Progression();
		x.reverse(new int[]	

				{5, 1, 11, 7, 17});
	}
}