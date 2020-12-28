#include <stdio.h>

#define max 100

void pecati_matrica(int *a, int m);
void zameni(int *a, int *b);
void modificiraj(int *a, int m);
int i, j;

int main() {
int a[max][max], m;

printf("Vnesete broj na elementi M:");
scanf("%d", &m);

printf("\nVnesete ja nizata:\n");

for (i=0;i<m;i++)
for (j=0;j<m;j++) {
printf("a[%d][%d]=", i, j);
scanf("%d", &a[i][j]);
}

printf("Nemodificiranata matrica e:\n");
pecati_matrica(a,m);

modificiraj(a,m);

printf("Modificiranata matrica e:\n");
pecati_matrica(a,m);

return 0;
}

void pecati_matrica(int *a, int m) {

for (i=0;i<m;i++) {
for (j=0;j<m;j++) printf("%d ", *(a+i*max+j));
printf("\n");
}
}

void zameni(int *a, int *b) {
int temp = *a;
*a = *b;
*b = temp;
}

void modificiraj(int *a, int m) {
for (i=0;i<m;i++)
for (j=0;j<m;j++) zameni(a+i*m+j, a+j*m+i);
}
