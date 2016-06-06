/*

Display the maximum number of consecutive non-vowels contained in a string.

e.g. "Hello World" -> "rld" with 3 non-vowels.
	
	Boro Sitnikovski, 24.10.2010
	
*/

#include <stdio.h>
#include <string.h>

#define check str[i] == 'a' || str[i] == 'e' || str[i] == 'i' || str[i] == 'o' || str[i] == 'u'
#define uint unsigned int

typedef struct consec {
	uint size;
	uint index;
} consec;

consec consecutive(char *str) {
	uint i, counter, j = strlen(str), inside=0;
	consec p = {0};

	for (i=0;i<=j;i++)
		if (inside && (check || str[i] == '\0')) {
			inside=0;
			if (counter>p.size) { p.size = counter; p.index = i; }
		}
		else if (inside) counter++;
		else if (!(check)) counter=inside=1;

	p.index-=p.size;
	return p;
}

int main(int argc, char *argv[]) {
	consec t;

	if (argc < 2) return -1;

	t = consecutive(argv[1]);
	
	if (argc == 3 && argv[2][0] == '1') {
		argv[1][t.index+t.size] = '\0';
		printf("%s\n", argv[1]+t.index);
	}

	return t.size;
}