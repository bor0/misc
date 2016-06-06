/*
 * The Totient Function (Euler's Function)
 *
 * Check this webpage for more information regarding algo:
 * http://mathworld.wolfram.com/TotientFunction.html
 *
 * By Euler's Theorem:
 * If a is a coprime to neN > 0 (GCD(a,n) == 1) then follows:
 * a^(phi(n)) = 1 (mod n);
 *
 * written by BoR0, 07.08.2006
 *
 */

#include <stdio.h>
#include <math.h>

//-----------------------------------

unsigned int landengcd(unsigned int m, unsigned int n) {
while(1) {
if((m %= n) == 0) return n;
if((n %= m) == 0) return m;
}
}

int calctotient(int number) {
int i,k;

k=0;

for (i=1;i<number;i++) if (landengcd(number, i) == 1) k++;

return k;

}

//-----------------------------------


int main() {
int i;

printf("Enter a number to calculate totient of: ");
scanf("%d", &i);

printf("EulerPhi[%d] = %d\n", i, calctotient(i));

return 0;

}
