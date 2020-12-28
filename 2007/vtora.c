#include <stdio.h>
#define BR_ELEMENTI 100

void pecati_niza(int *a, int m);
void zameni(int *a, int *b);
void modificiraj(int a[], int m);

int main() {
int a[BR_ELEMENTI], i, m;
printf("Vnesete broj na elementi M:");
scanf("%d", &m);
printf("\nVnesete ja nizata:\n");

for (i=0;i<m;i++) {
printf("a[%d]=", i);
scanf("%d", &a[i]);
}

printf("Nemodificiranata niza e:\n");
pecati_niza(a,m);

modificiraj(a,m);

printf("\nModificiranata niza e:\n");
pecati_niza(a,m);

return 0;

}

void pecati_niza(int *a, int m) {
int i=0;
while(m>i)
printf("%d  ", *(a+i++));
printf("\n");
}

void zameni(int *a, int *b) {
int temp = *a;
*a = *b;
*b = temp;
}

void modificiraj(int a[], int m) {
int i=0;

while (m>i) {
if (a[i]%2 != 0 && a[i+1]%2 != 0) { zameni(a+i, a+i+1); i++; }
i++;
}
}
