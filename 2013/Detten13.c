///////////////////////////////
//
// Boro Sitnikovski
//
// 04.01.2013
//

#include <stdio.h>

#define ROTATE_LEFT(x, n) (((x) << (n)) | (x >> (32 - n)))
#define ROTATE_RIGHT(x, n) (((x) >> (n)) | (x << (32 - n)))

unsigned int calc_hash(char *name, unsigned int serial) {
	unsigned int len = strlen(name), result = 0, i;

	for (i=0;i<len;i++) {
		result += name[i];
		result = ROTATE_LEFT(result, i);
		result ^= serial;
		result = ROTATE_RIGHT(result, i);
	}

	return result;
}

int check_hash(int result) {
	int i;

	// x = calc_hash() should produce a number that satisfies the following conditions:
	//
	// 1. -1073741825 < x < -65536 OR x > 65536
	// 2. for all n in [2, 65535], n does not divide x

	if (result <= 0xBFFFFFFF) return 0;

	for (i=2;i<65536;i++) {
		if (result % i == 0) return 0;
	}

	return 1;
}

int check_serial(char *name, unsigned int serial) {
	return check_hash(calc_hash(name, serial));
}

int main() {
	unsigned int i=0xC0000000;

	do {
		i++;
	} while (check_serial("a", i) == 0);

	printf("%u [%X]\n", i, (int)calc_hash("a", i));

	return 0;
}
