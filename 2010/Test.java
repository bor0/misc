//http://en.wikipedia.org/wiki/Repeating_decimal
// Conversely the period of the repeating decimal of a fraction c/d will be (at most) the smallest number n such that 10^n - 1 is divisible by d.
import java.*;
import java.math.*;
import java.util.*;

// ne raboti :)

public class Test {
	public static int getBiggestCycle(int start, int end) {
		int count = 0, number = 0;
		for (double j=start; j<=end; j++) {
			double x = 1.0/j;
			long bits = java.lang.Double.doubleToRawLongBits(x);
			String t = Long.toBinaryString(bits);
			t = new StringBuffer(t).reverse().toString();
			t = t.substring(12);
			for (int i=0;i<t.length();i++) {
				String p,q;
				try {
					p = t.substring(0,i);
					q = t.substring(i,i+i);
				} catch(Exception e){ continue; }
//				System.out.println(p + " vs " + q + "; " + i);
				if (p.equals(q)) {
//					System.out.println(q);
					if (q.length() > count) {
						count = q.length();
						number = (int)j;
					}
					//break;
				}
			}
		}
		return number;
	}
	
	static int getRepeatingCycle(int a, int b) {
		int i=1;
		float p = (float)a/b;
		float q = (float)a/b;
		while (true) {
			q *= 10;
			float c = (int)q;
			c /= Math.pow(10, i)-1;
			System.out.println(c + " " + p);
			if (c == p) break;
			i++;
		}
		return i;
	}


	public static void main(String[] args) {
		System.out.println(getBiggestCycle(1000, 3000));
		//System.out.println(getBiggestCycle(7, 7));
		return;
	}
};