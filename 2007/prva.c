#include <stdio.h>
#define BR_ELEMENTI 100
void preuredi(int *a, int m);

int main() {
int a[BR_ELEMENTI], i, j, m;
printf("Vnesete broj na elementi M:");
scanf("%d", &m);
printf("\nVnesete ja nizata:\n");
for (i=0;i<m;i++) {
printf("a[%d]=", i);
scanf("%d", &a[i]);
}
printf("\nNizata pred da se preuredi e:\n\n");
for (j=0;j<m;j++) printf("%10d", a[j]);
printf("\n");
preuredi(a,m);
printf("\nNizata po preureduvanjeto e:\n\n");
for (j=0;j<m;j++) printf("%10d", a[j]);
printf("\n");
return 0;
}

void preuredi(int *a, int m) {
int i=0,x=1;
while(i<m) {
*(a+i)=*(a+i++)*x;
x*=2;
}
}
