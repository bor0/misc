#include <stdio.h>

// SITNIKOVSKI BORO 13.04.2007

unsigned int a_no[5]; unsigned int b_no[5];

int convert(unsigned int number, unsigned int no[5]) {
no[4] = number%10;no[3] = (number%100)/10;
no[2] = (number%1000)/100;no[1] = (number%10000)/1000;
no[0] = number/10000;
return 0;
}

int main() {
int a,b,c,d,i,sum,carry;
FILE *pFile, *qFile;

pFile = fopen("prenos.in", "r");
fscanf(pFile, "%d", &b);

qFile = fopen("prenos.out", "w");

for (a=0;a<b;a++) {
sum = 0; carry = 0;

fscanf(pFile, "%d%d", &c, &d);
convert(c, a_no); convert(d, b_no);
for (i=4;i>=0;i--) {
if ((a_no[i] + b_no[i] + carry) > 9) {sum++;carry=1;}
else carry=0;
}

fprintf(qFile, "%d\n", sum);

}

fclose(pFile);
fclose(qFile);

return 0;
}
