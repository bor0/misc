#include <stdio.h>

int main() {

int a11,a12,a13=0;
int a21,a22,a23=0;
int a31,a32,a33=0;
int temp, results = 0;

printf("Determinants 3x3 calculator by BoR0\n\
===================================\n  | a11 \
a12 a13 | \n  | a21 a22 a23 | \nd=| a31 a32 a33 | \n\n");

printf("Define variables:\na11= ");
scanf("%d", &a11);
printf("a12= ");
scanf("%d", &a12);
printf("a13= ");
scanf("%d", &a13);

printf("a21= ");
scanf("%d", &a21);
printf("a22= ");
scanf("%d", &a22);
printf("a23= ");
scanf("%d", &a23);

printf("a31= ");
scanf("%d", &a31);
printf("a32= ");
scanf("%d", &a32);
printf("a33= ");
scanf("%d", &a33);

printf("\n\n(%d)*(%d)*(%d) + (%d)*(%d)*(%d) + (%d)*(%d)*(%d) \
- (%d)*(%d)*(%d) - (%d)*(%d)*(%d) - (%d)*(%d)*(%d) =\n",
a11, a22, a33, a12, a23, a31, a13, a21, a32, a31, a22, a13,
a32, a23, a11, a33, a21, a12);

temp = a11*a22*a33;
results+=temp;
printf("(%d)", temp);
temp = a12*a23*a31;
results+=temp;
printf(" + (%d)", temp);
temp = a13*a21*a32;
results+=temp;
printf(" + (%d)", temp);

temp = a31*a22*a13;
results-=temp;
printf(" - (%d)", temp);
temp = a32*a23*a11;
results-=temp;
printf(" - (%d)", temp);
temp = a33*a21*a12;
results-=temp;
printf(" - (%d) = %d\n\n", temp, results);

return 0;

}
