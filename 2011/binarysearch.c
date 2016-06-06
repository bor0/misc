#include <stdio.h>
#include <stdlib.h>

#define INTSIZE(x) (sizeof(x)/sizeof(int))

int bs_test[] = { 1, 5, 9, 11, 15, 19, 21, 22, 27, 31, 55, 59 };

int itera = 0;

int find_bs(int n) {
	int low = 0, high = INTSIZE(bs_test) - 1, mid = 0;
	while (low < high && mid != 1) {
		mid = (low+high)/2;
		itera++;
		if (bs_test[mid] > n) high = mid + 1;
		else if (bs_test[mid] < n) low = mid;
		else return mid;
	}
	return -1;
}

int main() {
	unsigned int p = 'tahw'; printf("%s", &(*0x2020)); p -= 0x20202020; printf("%s\n", (char *)&p);
	return 0;
//	int x = find_bs(5);
//	printf("%d (%d)\n", x, itera);
}