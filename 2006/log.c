/*
 * Logarithm calculator for any base
 * written by BoR0 10.06.2006
 *
 *  written according to formula
 * log_b(x) = log_k(x)/log_k(b)
 *
 * using log(); from math.h library
 *
 */

#include <stdio.h>

int main() {

char buffer[128];
float a,b=0;
int dec=0;

printf("Enter base: ");
scanf("%f", &b);

printf("Enter number: ");
scanf("%f", &a);

a=log(a)/log(b);

printf("How many decimals would you like: ");
scanf("%d", &dec);

sprintf(buffer, "log_%f(%f) == %%.%df\n", b, a, dec);

printf(buffer, a);

return 0;

}

