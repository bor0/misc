#include <stdio.h>

int main() {
int broj,broj2,nov;

printf("Vnesi broj: ");
scanf("%d", &broj);

nov = broj%10; broj2 = broj/10;

while (broj/10) { nov*=10; broj/=10; }

nov+=broj2;

printf("%d\n", nov);

return 0;

}
