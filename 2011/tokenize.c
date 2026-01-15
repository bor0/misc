#include <stdio.h>
#include <string.h>

int main() {

	FILE *t = fopen("onesec.txt", "r");
	char line[512], tokenize[512], sw, *p;

	while (!feof(t)) {
		fgets(line, sizeof(line), t);
		strcpy(tokenize, line);
		p = strtok(tokenize, "@.");
		sw = 0;

		while (p != NULL) {
			if (strncmp(p, "ein-sof", 7) == 0) sw++;
			else if (strncmp(p, "com", 3) == 0) sw++;
			p = strtok(0, "@.");
		}

		if (sw == 2) printf("%s", line);

	}
}