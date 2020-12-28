import java.util.ArrayList;
import java.util.List;

public class Positives {
	List<Integer> t = new ArrayList<Integer>();

	public int getPositiveCount(int[] numbers) {
		int l = numbers.length;
		System.out.println(l);
		int limit = (int)Math.pow(2, l) - 1;

		for (int i=0;i<=limit;i++) {
			String q = "";
			String p = Integer.toBinaryString(i);
			for (int j=0;j<l - p.length();j++) q+="0";
			q += p;

			int suma=0;

			for (int j=0;j<l;j++) {
				if (q.charAt(j) == '0') suma += numbers[j];
				else if(q.charAt(j) == '1') suma -= numbers[j];
			}
			if (suma >= 0 && t.contains(suma) == false) t.add(suma);

		}

		return t.size();
	}
}