#include <stdio.h>

int powi(int number, int exp) {
int a,b;
b=1;
for (a=0;a<exp;a++) b*=number;

return b;
}

int main() {
unsigned int computers = 0;
char a[16];
int i,n;

printf("How many computers? ");
scanf("%d", &n);

if (n<1 || n>32) {
printf("Not less than 1 and not more than 32.\n");
return 0;
}

for (i=0;i<n;i++) {
printf("Is computer no. %d turned on ? (y/n) ", i+1);
scanf("%s", &a);
if (a[0] == 'Y' || a[0] == 'y') computers ^= powi(2, i);
else if (a[0] != 'N' && a[0] != 'n') i--;
}

printf("Magical value: %d\n", computers);

return 0;
}
