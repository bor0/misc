#include <stdio.h>

int main() {
float a,b,c;
int i,j,k;
j=0;

printf("Enter chance of dodge/crit: ");
scanf("%f", &a);

printf("How many tries: ");
scanf("%d", &k);

if (a>100) {
printf("No larger than 100.\n");
return 0;
}

srandom(time(NULL));

for (i=0;i<k;i++) {

c = 100/a;
b = (10 * (random()%10)) + random()%10;

if (fmod(b,c) < 1) j++;

}

printf("From %d tries, %d were criticals/dodges.\n", k, j);


//srandom(time(NULL));
i = (10 * (random()%10)) + random()%10;
if (i == 0) i = 100;

printf("You rolled %d from 100\n", i);

return 0;

}
