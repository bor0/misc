/*

By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that the 6th prime is 13.

What is the 10001st prime number?

*/

#include <stdio.h>

int checkprime(int number) {
int i;

if (number == 1) return 0;

for (i=2;i<=number;i++) 
if ((number%i == 0) && (number != i)) return 0;

return 1;

}


int main() {
int i,n; int j=0;

printf("Print the first n primes. Define n: ");
scanf("%d", &n);

for (i=1;n!=j;i++)
if (checkprime(i)) {
j++;
printf("%d:\t%d\n", j, i);
}

return 0;

}
