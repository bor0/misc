#include <stdio.h>

char *nstrcpy(char *dst, char *src, int n) {
	int i=0;
	while ((i<n) && (src[i] != '\0') && (dst[i] = src[i++]));
	dst[i] = '\0';
	return dst;
}

int main() {
	char *a = "Pew pew laser";
	char b[50];
	strncpy(a,a,5);
	//nstrcpy(a, a, 5);
	printf("%s\n%s\n", a, b);
	return 0;
}
