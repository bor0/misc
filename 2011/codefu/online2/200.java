public class SMSOutcome {
	public String getSequence(String sentence) {
		String j = "";
		for (int i=0;i<sentence.length();i++) {
			if (sentence.charAt(i) == 'a') j += "2";
			else if (sentence.charAt(i) == 'b') j += "22";
			else if (sentence.charAt(i) == 'c') j += "222";
			else if (sentence.charAt(i) == 'd') j += "3";
			else if (sentence.charAt(i) == 'e') j += "33";
			else if (sentence.charAt(i) == 'f') j += "333";
			else if (sentence.charAt(i) == 'g') j += "4";
			else if (sentence.charAt(i) == 'h') j += "44";
			else if (sentence.charAt(i) == 'i') j += "444";
			else if (sentence.charAt(i) == 'j') j += "5";
			else if (sentence.charAt(i) == 'k') j += "55";
			else if (sentence.charAt(i) == 'l') j += "555";
			else if (sentence.charAt(i) == 'm') j += "6";
			else if (sentence.charAt(i) == 'n') j += "66";
			else if (sentence.charAt(i) == 'o') j += "666";
			else if (sentence.charAt(i) == 'p') j += "7";
			else if (sentence.charAt(i) == 'q') j += "77";
			else if (sentence.charAt(i) == 'r') j += "777";
			else if (sentence.charAt(i) == 's') j += "7777";
			else if (sentence.charAt(i) == 't') j += "8";
			else if (sentence.charAt(i) == 'u') j += "88";
			else if (sentence.charAt(i) == 'v') j += "888";
			else if (sentence.charAt(i) == 'w') j += "9";
			else if (sentence.charAt(i) == 'x') j += "99";
			else if (sentence.charAt(i) == 'y') j += "999";
			else if (sentence.charAt(i) == 'z') j += "9999";
			else if (sentence.charAt(i) == ' ') j += "0";
		}
		return j;
	}
}