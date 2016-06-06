// example done by Bor0
// based on Babylonian formula
// feel free to use/reproduce with sending credits kthx ;-)

#include <stdio.h>

double nthroot(double number, double n) {

double x = 1;
double y = 0;

while (1) {
x = (n*x - x + (number/pow(x,n-1)))/n;
if (x==y) break;
y = x; // Jibz :))
}

return x;

}

int main() {

float input = 0;
float n = 0;

printf("Type in the number you want to take nthroot of: ");
scanf("%f", &input);

printf("Which root: ");
scanf("%f", &n);

printf("Root (positive): %.22f\n", nthroot(input, n));

return 0;

}
