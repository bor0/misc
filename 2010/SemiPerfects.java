import java.util.*;

public class SemiPerfects {
	public static boolean isprime(int n) {
		if (n < 2) return false;
		if (n % 2 == 0) return (n == 2);
		for (int i=3; i*i<=n; i+=2) if (n%i == 0) return false;
		return true;
	}
	
	public static int count(int start, int end) {
		List<Integer> l = new ArrayList<Integer>();
		List<Integer> m = new ArrayList<Integer>();
		int i,sum=0;
		l.add(0);
		for (i=0;i<5001;i++) if (isprime(i)) l.add(i);
		for (i=1;i<l.size();i++) if (Integer.toString(i).equals(new StringBuffer(Integer.toString(i)).reverse().toString()))
			m.add(l.get(i));

		for (i=start;i<=end;i++) if (m.contains(i)) sum++;
		return sum;
	}
	public static void main(String[] args) {
		System.out.println(count(191, 1530));
		System.out.println(count(1, 5000));
		return;
	}
}