public class BestLocals {
  public String getLocalBest(int[] points, String[] names, int start, int end) {
    int bestindex=start,max=points[start];
    for (int i=start;i<=end;i++) if (max < points[i]) {
max = points[i];
bestindex = i; 
}
    return names[bestindex];
  }
}