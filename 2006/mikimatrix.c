#include <stdio.h>

#define max 10

int intswap(int *x1, int *x2) {

int z=*x1;

*x1=*x2;

*x2=z;

return 0;

}


int main() {
int n=0;
int i,x=0;

int moo[max][max];
int moo2[max*max-max];

FILE *pFile = fopen( "matricaA.txt", "r" );

printf("Vnesi n kade matricata ima nxn clenovi: ");
scanf("%d", &n);

if (n>max) {
	printf("ja nadmina vrednosta na n.");
	return 0;
}

for (i=0;i<n;i++) for (x=0;x<n;x++) fscanf(pFile, "%d", &moo[x][i]);
for (x=0;x<n;x++) for (i=0;i<n-1-x;i++) intswap(&moo[i][x], &moo[n-1-x][n-1-i]);

fclose(pFile);

pFile = fopen( "nova.txt", "w+" );

for (i=0;i<n;i++) {
for (x=0;x<n;x++) fprintf(pFile, "%d ", moo[x][i]);
fprintf(pFile, "\n");
}

fclose(pFile);

return 0;

}

