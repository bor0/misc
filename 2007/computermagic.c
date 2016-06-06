//by bor0

/*
P_1 * P_2 * P_3 * ... * P_n e unikaten produkt
ako samo eden prost broj se razlikuva togas produktot se menuva
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
char a[16];

printf("How many computers do you own? ");
scanf("%d", &n);

int computer[n];

for (i=1;n!=j;i++) if (checkprime(i)) computer[j++] = i;

j=1;

for (i=0;i<n;i++) {
printf("Is computer no. %d ON ? (y/n) ", i+1);
scanf("%s", &a);
if (a[0] == 'Y' || a[0] == 'y') j*=computer[i];
else if (a[0] != 'N' && a[0] != 'n') i--;
}

printf("Magic value: 0x%X = ", j);

for (i=2;(i<j+1) && (j != 1);i++) {
if (j%i == 0) {
j/=i;
printf("%d * ", i);
i--;
}
}

printf("1\n");

return 0;

}
