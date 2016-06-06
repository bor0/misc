#include <stdio.h>

int main() {

	char word[255], *temp=0;
	int h=0,i,j,k=0,l;
	//h is the word counter
	//i is a counter for our loop
	//j is the length of the input
	//k is the space index + 1
	//l is a temporary variable for the new mem. allocation

	printf("Enter a phrase\n");
	gets(word); // not safe!
	j = strlen(word);
	printf("%i\n", j);

	for (i=0;i<=j;i++) if (isspace(word[i]) || word[i] == '\0') {

		word[i] = '\0';
		l = strlen(word+k);

		if (temp) free(temp);
		temp = malloc(l+1);
		strcpy(temp, word+k);
		temp[l] = '\0';

		printf("%d) %s\n", h++, temp);
		k=i+1; word[i] = ' ';

	}

	if (temp) free(temp);
	system("PAUSE");

	return 0;

}

