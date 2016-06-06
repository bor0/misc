#include <stdio.h>
#include <string.h>

#define MAXLENGTH 512

int main(int argc, char **argv) {

	char line[MAXLENGTH];
	int i, j, k;

	if (argc == 1) return 0;

	k = strlen(argv[1]);

	while (fgets(line, sizeof(line), stdin) != NULL) {
		j = strlen(line);
		for (i=0;i<j-k;i++) if (strncmp(line+i, argv[1], k) == 0) {
			printf("%s", line);
			break;
		}
	}

	return 0;
}