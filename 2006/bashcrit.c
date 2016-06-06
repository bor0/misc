#include <stdio.h>

/*int testcrit(int chance) {

if ((rand() % (chance*1/100)) == 0) return 1;
else return 0;

}*/


int main() {

int n,a,x;
float z;

printf("Bash/critical calculator v1.0 by BoR0\n");
printf("Type -1 in numbers of calc. to exit.\n\n");

while (1) {

printf("How many calculations should be done: ");
scanf("%d", &n);

if (n==-1) break;

z=1;

for (x=1;x<=n;x++) {
printf("Enter chance no.%d: ", x);
scanf("%d", &a);

if (a==-1) break;

if (a>=100) {
printf("Chance cannot be higher or equal to 100%%.\n");
x--;
continue;
}

z*=(1-a*.01);

}

if (a==-1) break;

z=1-z;

z*=100;

printf("Your chance is %.2f%%\n\n", z);

}

return 0;

}

