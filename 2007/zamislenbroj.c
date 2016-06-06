//zamisli broj od 1..15
#include <stdio.h>

int main() {
int niza[15];
int i,temp,poo;

for (i=0;i<15;i++) niza[i]=0;

printf("Se odgovara so (1) za da, ili (-1) za ne!!\n");

printf("1, 3, 5, 7, 9, 11, 13, 15\n");
printf("Dali zamisleniot broj se naoga vo gore-navedenata niza:\n");
scanf("%d", &i);

niza[0] += i; niza[2] += i;
niza[4] += i; niza[6] += i;
niza[8] += i; niza[10] += i;
niza[12] += i; niza[14] += i;

printf("2, 3, 6, 7, 10, 11, 14, 15\n");
printf("Dali zamisleniot broj se naoga vo gore-navedenata niza:\n");
scanf("%d", &i);

niza[1] += i; niza[2] += i;
niza[5] += i; niza[6] += i;
niza[9] += i; niza[10] += i;
niza[13] += i; niza[14] += i;

printf("4, 5, 6, 7, 12, 13, 14, 15\n");
printf("Dali zamisleniot broj se naoga vo gore-navedenata niza:\n");
scanf("%d", &i);

niza[3] += i; niza[4] += i;
niza[5] += i; niza[6] += i;
niza[11] += i; niza[12] += i;
niza[13] += i; niza[14] += i;

printf("8, 9, 10, 11, 12, 13, 14, 15\n");
printf("Dali zamisleniot broj se naoga vo gore-navedenata niza:\n");
scanf("%d", &i);

niza[7] += i; niza[8] += i;
niza[9] += i; niza[10] += i;
niza[11] += i; niza[12] += i;
niza[13] += i; niza[14] += i;

temp = 0;
for (i=0;i<15;i++) if (niza[i] > temp) { temp = niza[i]; poo = i; }

printf("Brojce %d\n", ++poo);

return 0;

}
