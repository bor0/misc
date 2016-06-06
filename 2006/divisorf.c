/*
 * The Divisor Function
 *
 * For more information regarding algo visit
 * http://mathworld.wolfram.com/DivisorFunction.html
 *
 * written by Bor0, 08.08.2006
 *
 */


#include <stdio.h>

int powi(int number, int exp) {
int a,b;
b=1;
for (a=0;a<exp;a++) b*=number;

return b;
}

int divisor_f(int number, int index) {
int a,b;

b=0;

for (a=1;a<=number;a++) if ((number%a) == 0) b+=powi(a,index);

return b;

}


int main() {
int i,x;

printf("Enter number to calculate divisor function of: ");
scanf("%d", &i);

printf("Which index: ");
scanf("%d", &x);

printf("%d\n", divisor_f(i,x));
return 0;

}
