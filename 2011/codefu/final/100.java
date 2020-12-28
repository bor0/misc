public class AlternativePermutation {
    public String getAlternative(String permutation) {
        String[] vals = permutation.split(" "), vals2 = new String[vals.length];
        String t = "";
        for (int i=0;i<vals.length;i++) vals2[Integer.parseInt(vals[i])] = String.valueOf(i);
        for (int i=0;i<vals2.length;i++) t += vals2[i] + " ";
        return t.trim();
    }
}