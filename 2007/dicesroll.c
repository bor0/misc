#include <stdio.h>

int main() {
int dices,i;
printf("How many dices: ");
scanf("%d", &dices);

int dice[dices];

srand(time(NULL));

for (i=0;i<dices;i++) {
dice[i] = rand()%6; if (dice[i] == 0) dice[i] = 6;
printf("Dice no. %d rolled: (%d - 6)\n", i+1, dice[i]);
}

return 0;

}
