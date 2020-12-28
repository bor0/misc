#include <stdio.h>

// SITNIKOVSKI BORO 22.04.2007

int conversion(unsigned long number) {
unsigned long i,x;
x=1000000;

for (i=0;i<=6;i++) {
if ((number/x)%10 != 0) break;
x/=10;
}

return i;
}

int main() {
unsigned long i,sum;

FILE *pFile = fopen("cifri.in", "r");
FILE *qFile = fopen("cifri.out", "w");

fscanf(pFile, "%ld", &i);

sum = 0;

for (i=i; i>0; i--) sum += 7 - conversion(i);

fprintf(qFile, "%ld\n", sum);

fclose(pFile);
fclose(qFile);

return 0;

}