#include <stdio.h>

int main() {
int a,b,c;

int dices[5];

printf("How many tries: ");
scanf("%d", &b);

srandom(time(NULL));

c=0;

for (a=0;a<b;a++) {

dices[0] = random()%6;dices[1] = random()%6;
dices[2] = random()%6;dices[3] = random()%6;
dices[4] = random()%6;

if ((dices[0]==dices[1]) && (dices[1]==dices[2]) && (dices[2]==dices[3]) && (dices[3]==dices[4])) c++;

if ((a%100==0) || (a==b-1)) printf("\r(%d): %d/%d = %.25f (%f%%)", a+1, c, b, (float)c/b, (float)(c*100)/b);

}

printf("\n");

return 0;

}
