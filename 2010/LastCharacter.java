public class LastCharacter {

	public String findLast(String s, int N) {

		int index = (int)(Math.pow(2,(int)(Math.log((double)(s.length()*N))/Math.log(2.0))));
		index %= s.length();
		if (index == 0) index = s.length();
		index--;
		return String.valueOf( s.charAt(index) );

	}

}