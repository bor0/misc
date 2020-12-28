public class HexPalindroms {
    public boolean isPalin(String t) {
        int k = t.length();
        for (int i=0,j=k-1;i<k/2;i++,j--) if (t.charAt(i) != t.charAt(j)) return false;
        return true;
    }
    public int getHexPalindromes(int start, int end) {
        int count=0;
        for (int i=start;i<=end;i++) {
            String t = Integer.toString(i, 16);
            if (isPalin(t) == true) count++;
        }
        return count;
    }
}