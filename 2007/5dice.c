#include <stdio.h>

//Frlame 6 kocki. Kolkava e verojatnosta da padne isti broj na 5 kocki ?

//Prv program napisan na lap-top :)

int main() {
int a[6], i, score;

i = 1; score = 0;

for (a[0]=1;a[0]<=6;a[0]++)
for (a[1]=1;a[1]<=6;a[1]++)
for (a[2]=1;a[2]<=6;a[2]++)
for (a[3]=1;a[3]<=6;a[3]++)
for (a[4]=1;a[4]<=6;a[4]++)
for (a[5]=1;a[5]<=6;a[5]++) {
if ((a[1] == a[2] && a[2] == a[3] && a[3] == a[4] && a[4] == a[5]) ||\
(a[0] == a[2] && a[2] == a[3] && a[3] == a[4] && a[4] == a[5]) ||\
(a[0] == a[1] && a[1] == a[3] && a[3] == a[4] && a[4] == a[5]) ||\
(a[0] == a[1] && a[1] == a[2] && a[2] == a[4] && a[4] == a[5]) ||\
(a[0] == a[1] && a[1] == a[2] && a[2] == a[3] && a[3] == a[5]) ||\
(a[0] == a[1] && a[1] == a[2] && a[2] == a[3] && a[3] == a[4])) score++;

//printf("Turn no. %d: %d%d%d%d%d%d (%d)\n", i, a[0], a[1], a[2], a[3], a[4], a[5], score);

i++;
}

printf("Total chance: %d/%d (%.5f%%)\n", score, i, (float)score/i * 100);

return 0;

}