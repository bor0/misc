#include <stdio.h>

// every single byte written by Bor0, 02/07/2006 :-)

float fact(float i) {
float z=1;
float x;
for (x=1;x<=i;x++) z*=x;
return z;
}

int main() {
float i;
float p,x,sum=0;

printf("This program will solve for x using some of Taylors series.\n\n");
printf(" 1. e^x = sum [ (x^n)/(n!) ]  n = 0 to oo\n");
printf(" 2. sin(x) = sum [ ((-1^n)*(x^(2n+1)))/(2n+1)! ]  n = 0 to oo\n");
printf(" 3. cos(x) = sum [ ((-1^n)*(x^2n))/(2n)! ]  n = 0 to oo\n");
printf("\n\n Enter value for x: ");

scanf("%f", &x);

for (i=0;;i++) {

//p=(pow(-1,i) * pow(x, 2*i+1))/fact(2*i+1); //sin(x);
//p=(pow(-1,i) * pow(x, 2*i))/fact(2*i); //cos(x);
p=pow(x,i)/fact(i); //e^x;

if (!p) break;

sum+=p;

}

printf("n=%f; => %.5f\n", i, sum);

return 0;

}
