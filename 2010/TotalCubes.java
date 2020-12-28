public class TotalCubes {
  public int howMany(int A, int B) {
    int sum = 0;
    for (int i=A;i<=B;i++) if (Math.cbrt(i) == (int)Math.cbrt(i)) sum++;
    return sum;
  }
}