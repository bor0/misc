#include <stdio.h>
#include <string.h>

int is_easy_digit(char *s) {
	int len = strlen(s);
	return len == 2 || len == 3 || len == 4 || len == 7;
}

int main() {
	char buffer[1024];
	char numbers[4][16];
	FILE *t = fopen("input", "r");
	int s = 0;
	int i = 0;

	while (fgets(buffer, sizeof(buffer) - 1, t) != NULL) {
		sscanf(buffer, "%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s | %s %s %s %s", numbers[0], numbers[1], numbers[2], numbers[3]);

		for (i = 0; i < 4; i++) {
			if (is_easy_digit(numbers[i])) s++;
		}
	}

	fclose(t);

	printf("%d\n", s);
	return 0;
}
