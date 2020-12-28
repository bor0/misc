


public class TestPrize {

	public static int getPrizeWinner(int [] numbers, int [] factors, int modulo) {
		int sum = 0;
		java.util.Arrays.sort(numbers);
		for (int i=0;i<factors.length;i++) sum += factors[i] * numbers[i];
		sum = sum%modulo + 2;
		return sum;
	}
	
	public static void main(String[] args) {
		System.out.println(getPrizeWinner(new int []{ 21, 23, 38, 47, 50 }, new int []{ 2, 5, 8, 11, 13 }, 109));
/*		int winners[] = new int[111];
		System.out.println("Starting process..");
		for (int i=1;i<=50;i++)
			for (int j=1;j<=50;j++)
				for (int k=1;k<=50;k++)
					for (int l=1;l<=50;l++)
						for (int m=1;m<=50;m++)
							if (i == j || i == k || i == l || i == m || j == k || j == l || j == m || k == l || k == m || l == m) continue;
							else winners[getPrizeWinner(new int []{ i, j, k, l, m }, new int []{ 2, 5, 8, 11, 13 }, 109)]++;
		for (int i=0;i<111;i++) System.out.println("No." + i + ": " + winners[i]);*/
		}
}
