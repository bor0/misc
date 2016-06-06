#include <stdio.h>

int main() {
	int rmin = 1, rmax, tmp, i = 0, last = 0;
	char c;

	printf("Enter maximum bound: ");
	scanf("%d", &rmax);

	if (rmax < 1) return 0;

	printf("Enter q for less, w for more, or e for correct\n");

	while (1) {
		tmp = (rmax+rmin)/2;

		if (last == tmp) {
			printf("Correct number is %d\n", tmp);
			break;
		}

		printf("(%d) %d\n", ++i, tmp);
		last = tmp;

		getchar(); // \n
		c = getchar();

		if (c == 'e') {
			printf("Correct number is %d\n", tmp);
			break;
		}
		else if (c == 'q') rmax = tmp;
		else if (c == 'w') rmin = tmp;
		else break;
	}

	return 0;
}
	