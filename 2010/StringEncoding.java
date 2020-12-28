public class StringEncoding {
  public String encode(String s) {
    char c = s.charAt(0); int p = 0;
    String t = "";
    for (int i=0;i<s.length();i++,p++) {
	if (s.charAt(i) != c) {
        String tmp = "";
        if (p != 1) tmp = String.valueOf(p);
        t = t + c + tmp;
	p=0;
        c = s.charAt(i);
}
}
if (p != 0) {
        String tmp = "";
        if (p != 1) tmp = String.valueOf(p);
	t = t + c + tmp;
}
    return t;
  }
}