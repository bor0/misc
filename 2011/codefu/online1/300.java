public class HighestCharacter {
    public static String checkcontents(String a, String b) {
        int i = a.length()-1; int j = b.length()-1; int x,y;
        for (x=i,y=j;x>=0&&y>=0;x--,y--) {
                //System.out.println("Comparing chars " +a.charAt(x) +" and " + b.charAt(y));
                if (a.charAt(x) > b.charAt(y)) return a;
                else if (a.charAt(x) < b.charAt(y)) return b;
            }
        return a;
    }

  public static String highest(String[] strings) {
      java.util.Arrays.sort(strings);
      String[] TheStrings = new String[512];
      int index=0;
      for (int i=0;i<strings.length;i++) {
          char array[] = strings[i].toCharArray();
          java.util.Arrays.sort(array);
          String s = new String(array);
          TheStrings[i] = s;
      }
      for (int i=0;i<strings.length-1;i++) {
          //System.out.println("Battle between " + strings[i] + " and " + strings[i+1]);
          TheStrings[i+1] = checkcontents(TheStrings[i], TheStrings[i+1]);
      }
      for (int i=0;i<strings.length;i++) {
          char array[] = strings[i].toCharArray();
          java.util.Arrays.sort(array);
          String s = new String(array);
          if (s.equals(TheStrings[strings.length-1])) return strings[i];
      }
      return "";
  }

}