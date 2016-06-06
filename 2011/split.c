#include <stdio.h>

struct split_info {
	char **array;
	int elements;
};

struct split_info split(char *str, char sep) {
	struct split_info splitinfo;
	int i, j, k=0, l=0;
	j = strlen(str);

	splitinfo.elements = 1;

	for (i=0;i<j;i++) if (str[i] == sep) splitinfo.elements++;

	splitinfo.array = (char **)malloc(splitinfo.elements*(sizeof(char*)));

	for (i=0;i<=j;i++) if (str[i] == sep || str[i] == '\0') {
		splitinfo.array[l] = (char *)malloc((i-k+1)*(sizeof(char)));
		strncpy(splitinfo.array[l], str+k, i-k);
		splitinfo.array[l][i-k] = '\0';
		l++; k=i+1;
	}

	return splitinfo;
}

void printsplit(struct split_info *splitinfo) {
	int i;
	for (i=0;i<splitinfo->elements;i++)	printf("(%d) %s\n", i, splitinfo->array[i]);
	return;
}

void freesplit(struct split_info *splitinfo) {
	int i;
	for (i=0;i<splitinfo->elements;i++)	free(splitinfo->array[i]);
	free(splitinfo->array);
	return;
}

int main() {
struct split_info splitinfo;
splitinfo = split("a;b;c;d;e;f", ';');
printsplit(&splitinfo);
freesplit(&splitinfo);
return 0;
}
