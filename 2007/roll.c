#include <stdio.h>

int test[100];

int main() {
int sum,i;
int x,y;

srand(time(NULL));

for (x=0;x<1000000;x++) {
y = rand()%100;
if (y == 0) y = 100;
test[y-1]++;
}

i = 0;
for (x=0;x<100;x++) if (test[x] > test[i]) i = x;

printf("You roll (%d - 100)\n", i);
return 0;

}

