/*

2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.

What is the smallest number that is evenly divisible by all of the numbers from 1 to 20?

*/

#include <stdio.h>
#define number 20

int main() {
int a,b;
b=2;

while(1) {
for (a=1;a<=number;a++) if (b%a != 0) break;
if (a==number+1) break;
b++;
}

printf("%d\n", b);

return 0;

}
