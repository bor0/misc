public class Photographer {
	public String getResolution(String[] pics) {

		int max = 0;

		for (int i=0;i<pics.length;i++) {
			String[] t = pics[i].split("x");
			int z = Integer.parseInt(t[0])*Integer.parseInt(t[1]);
			if (z > max) max = z;
		}

		return String.valueOf(max/1000000.0).format("%.1f", qq).replace(",", ".");;
	}
}