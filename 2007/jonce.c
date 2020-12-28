// SITNIKOVSKI BORO 13.04.2007

#include <stdio.h>

int main() {
int a,b,sum;

FILE *pFile = fopen("jonce.in", "r");

sum = 0;

while (fscanf(pFile, "%d", &a) != EOF) {

b=a/10;
a=a%10;
a=a*10 + b;
sum+=a;

}

fclose(pFile);

pFile = fopen("jonce.out", "w");
fprintf(pFile, "%d", sum);

return 0;

}
