#include <stdio.h>

int obratno(int n, int x) {
	if (n == 0) {
		return x;
	}

	return obratno(n/10, (x * 10) + (n%10));
}

// Matematicka formula:
// f 0 x = x
// f n x = f(|_n/10_|, 10x + k), n = k (mod 10) 

int main() {
	int n;

	printf("Broj: ");
	scanf("%d", &n);

	printf("%d\n", obratno(n, 0));

	return 0;
}
