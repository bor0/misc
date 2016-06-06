#include <stdio.h>
#include <malloc.h>


1 2 3 5 6 63 3 

int main() {
	int i, j, k;
	int xindex1, xindex2, nindex1, nindex2;
	int *myarray;
	int summax, summin, tempsum;

	k=sizeof(myarray)/(sizeof(int));

	printf("Enter the size of the array: ");
	scanf("%d", &k);

	myarray = (int *)malloc(sizeof(int)*k);

	for (i=0;i<k;i++) {
		printf("Enter number %d: ", i+1);
		scanf("%d", &myarray[i]);
	}

	summax = summin = myarray[0];
	xindex1 = xindex2 = nindex1 = nindex2 = 0;

	for (i=0;i<k;i++) {
		tempsum=0;
		for (j=i;j<k;j++) {
			tempsum+=myarray[j];
			if (tempsum > summax) {	summax = tempsum; xindex1 = i; xindex2 = j; }
			if (tempsum < summin) {	summin = tempsum; nindex1 = i; nindex2 = j; }
		}
	}

	free(myarray);

	printf("max sum array start index %d, max sum array end index %d, max sum %d\n", xindex1, xindex2, summax);
	printf("min sum array start index %d, min sum array end index %d, min sum %d\n", nindex1, nindex2, summin);

	return 0;
}