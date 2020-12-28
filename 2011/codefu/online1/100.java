public class SmallestPair {
  public int smallest(int[] numbers) {
    int min=numbers[0]+numbers[1];
      for (int i=0;i<numbers.length-1;i++)
        if (numbers[i]+numbers[i+1]<min) min=numbers[i]+numbers[i+1];
  return min;
  }
}