/*
 * This program converts any number base to decimal.
 * Now updated: It can also convert decimal to any other base.
 *
 * written by Bor0 (20.09.2006)
 *
 */

#include <stdio.h>
#include <math.h>

int i,l,m=0;
float j,x=0;

int main() {

char i[64];
int x=0;

printf("Enter number: ");
fgets(i, 63, stdin);

for (x=0;;x++) if (i[x] == 10) break;
if (!x) return 0; i[x]=0; x=0;

printf("From which number system do I read it? (converting to decimal): ");
scanf("%d", &x);

printf("Converted number: %d\n", any_to_decimal(i, x));

printf("Enter number (decimal): ");
scanf("%d", &l);

printf("Enter base to convert the number to: ");
scanf("%d", &m);

printf("Converted number: "); decimal_to_any(l, m);

return 0;

}

int any_to_decimal(char *broj, int k) {

j=strlen(broj);

for (i=0;i<j;i++) {

if ((broj[i] >= 65) && (broj[i] <= 90)) {
broj[i]-=7;
} else if ((broj[i] >= 97) && (broj[i] <= 122)) broj[i]-=39;

broj[i]-=48;

if (broj[i] >= k) {
printf("Error! I got number %d which is higher or equal to its base.\n", broj[i]);
return 0;
}
}

for (j;;j--,m++) {

x=pow(k, j-1);
i=x*broj[m];
l+=i;

if (j==1) break;

}

return l;
}

int decimal_to_any(int number, int base) {
char buffer[16];

i = number;

for (l=0;i!=0;l++) {
buffer[l] = i%base;
i /= base;
}

if (!l) return printf("0\n");

for (i=1;i<=l;i++) printf("%d", buffer[l-i]);
printf("\n");

return 0;

}
