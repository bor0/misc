#include <stdio.h>

int greskatest(int a) {
if (a > 4 || a < 1) {
printf("Broevite mora da se naogaat pomegu 1 i 4.\n");
return 0;
}
return 1;
}

int main() {
int niza[4], vnesi[4], x, y;

srand(time(NULL));

for (x=0;x<4;x++) {
y = rand()%4;
if (y == 0) y = 4;
niza[x] = y;
}

while (1) {
y=0;
printf("Vnesi 4 broja: ");
scanf("%d%d%d%d", &vnesi[0], &vnesi[1], &vnesi[2], &vnesi[3]);

if (greskatest(vnesi[0]) == 0) continue;
if (greskatest(vnesi[1]) == 0) continue;
if (greskatest(vnesi[2]) == 0) continue;
if (greskatest(vnesi[3]) == 0) continue;

if (vnesi[0] == niza[0]) y++; if (vnesi[1] == niza[1]) y++;
if (vnesi[2] == niza[2]) y++; if (vnesi[3] == niza[3]) y++;

printf("%d od 4 se na svoite mesta.\n", y);

if (y == 4) break;
}

return 0;

}

