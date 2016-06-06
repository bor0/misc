#include <stdio.h>

struct b {
	int d;
};

struct a {
	struct b *c;
};

int main() {

	struct b A1; struct a A2;

	A2.c = &A1;
	A1.d = 3;

	printf("%d\n", A1.d);

	printf("%d\n", A2.c->d); // OK!    <--------\
	// printf("%d\n", (*A2.c).d); // equivalent |
	// printf("%d\n", A2.(*c).d); // invalid.

	return 0;

}