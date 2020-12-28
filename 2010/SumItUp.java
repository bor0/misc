public class SumItUp {
  public int sum(int N) {
if (N<10) return N;
int s=0;
while(N>0) {
s+=N%10;
N/=10;
}
return sum(s);
  }
}