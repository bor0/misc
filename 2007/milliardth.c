#include <stdio.h>

#define WHAT 1000000000

/*

If you write all of the positive integers in a single digit sequence,
12345678910111213..., what's its 1,000,000,000th digit?

Takes a while to run :)

Written by BoR0 06.07.2007

*/

int intlen(int i) {
int z = 0;

while (i != 0) {
i /= 10;
z++;
}

return z;
}


int main() {
int i,t;
char digit[16];

if (WHAT <= 0) return 0;

for (i=1,t=0;t<=WHAT-1;i++) t+=intlen(i);
i = sprintf(digit, "%d", i-1);

while (t != WHAT-1) { t--; i--; }

printf("The digit on %d-th place is %c.\n", WHAT, digit[i]);

return 0;

}
