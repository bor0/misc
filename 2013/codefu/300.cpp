#include<string>
#include <vector>
using namespace std;

class ArraySum
{
	public:
	int L[10];
	int findDigit(int N) {
		if (N == 0 || N == 1) return 1;
		int lastsum, count;
		lastsum = count = 2;

		while (count <= N) {
			int i = 0, n = lastsum;
			memset(L, 0, 10);

			while(n != 0) {
				L[i] = n%10;
				lastsum = lastsum + L[i++];
				n /= 10;
				count++;
			}

		}

		return L[count-N-1];
	}
};