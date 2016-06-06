#include <stdio.h>
#include <math.h>
#include <string.h>

void powertwo(int x, int *y) {
	int a,b=0;

	while (x != 0) {
		for (a=0;pow(2,a)<x;a++) {};
		if (pow(2,a) != x) a--;
		y[b++] = a;
		x-=pow(2,a);
	}

	y[b] = -1;
	return;
}

int main(int argv, char **argc) {
	int array[512], i, x, y;

	if (argv != 2) return 0;
	y = atoi(argc[1])+1;
	
	for (x=1;x<y;x++) {
		i=0;
		powertwo(x, array);
		printf("%d: ", x);
		while (array[i] != -1) printf("%d ", array[i++]);
		putchar('\n');
	}

	return 0;
}