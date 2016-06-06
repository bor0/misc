#include <stdio.h>

int main(int argc, char **argv) {
	int size = 1024, i = 0;
	unsigned int sum = 0;

	printf("Memory breaker  by BoR0\n-=-=-=-=-=-=-=-=-=-=-=-\n\n");

	if (argc == 2) {
		size = atoi(argv[1]);
		printf("Upper-bound size (default: 1024 bytes) is now '%d' bytes.\n", size);
	}

	printf("Please wait, allocating...\n");

	while (1) {
		if (!malloc(size)) {
			if (--i) {
				printf("Memory of size [%d] bytes allocated %d times.\n", size, i);
				sum+=i*size;
			}
			size--; i=0;
		}
		if (!size) break;
		i++;
	}

	printf("\nTotal alloc.: %u bytes (%.2f MBytes).\nDone.\n", sum, (float)sum/1048576);

	return 0;

}
