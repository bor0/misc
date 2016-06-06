#include <stdio.h>

int main() {
int huh[16];
int i,x,temp;

srandom(time(NULL));
printf("Randomizirana niza: ");

for (i=0;i<16;i++) {
huh[i] = rand()%9;
printf("%d, %d\n", i+1, huh[i]);
}

for (i=0;i<16;i++)
for (x=0;x<16;x++)
if (huh[i] > huh[x]) {
temp = huh[x];
huh[x] = huh[i];
huh[i] = temp;
}

printf("Sredena so bubblesort: ");

for (i=0;i<16;i++) printf("%d, %d\n", i+1, huh[i]);

return 0;

}
