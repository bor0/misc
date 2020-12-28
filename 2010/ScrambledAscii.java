public class ScrambledAscii {

	public static String weights(int[] charValues, String sentence) {
		String alphabet = "abcdefghijklmnopqrstuvwxyz";
		String t = new String();
		sentence = sentence + " ";
		for (int i=0,j,sum=0;i<sentence.length();i++) {
			if (sentence.charAt(i) == ' ') {
				t = t + " " + Integer.toString(sum);
				sum = 0;
				continue;	
			}

			for (j=0;j<alphabet.length();j++) if (sentence.charAt(i) == alphabet.charAt(j)) break;
			sum += charValues[j];

		}

		return t.trim();

	}
	
	public static void main(String[] args) {
		int charValues[] = {3, 29, 83, 30, 71, 28, 24, 47, 17, 60, 41, 81, 23, 85, 92, 76, 22, 42, 35, 46, 63, 59, 98, 26, 53, 9};
		String sentence = "kqqznzekroqjug xodthgi jvuq ms bad qhai md pdiwgb hzcbcrax";

		System.out.println(weights(charValues,sentence));
	}
}