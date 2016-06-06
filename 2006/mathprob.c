#include <stdio.h>

#define max 4
#define details 0

int test[max];

int runtest() {

int i,z,x,j,binrapt;

binrapt = 0; // LOL BINRAPT EQUALS ZERO NEWB

for (i=1;;i++) {

z = rand()%max;

if (test[z] == 0) {
test[z] = 1;
binrapt++;
if (details) printf("%d: Picked %d.\n", i, z);
} else {
if (details) printf("%d: Picked %d (duplicate).\n", i, z);
test[z]++;
}

if (binrapt == max) break;

}

if (details) printf("After %d tries, they were all picked up.\n", i);


for (z=0;z<max;z++) 
for (x=0;x<max-2;x++) 
if (test[z] > test[x]) {

j=test[z];
test[z] = test[x];

test[x]=j;

}

if (details) printf("Packs that needs to be bought for this run: %d\n", test[0]);

return i;

}

int main() {
int i,x;
double z=0;

srand(time(NULL));

for (i=0;i<0x500000;i++) {

for (x=0;x<=max;x++) test[x]=0;

z+=runtest();

if (details) printf("-----------------------------\nNow rolling number: %d\n", i);

}

z/=i;

printf("Average shiath: %f\n", z);

return 0;

}
