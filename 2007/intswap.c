#include <stdio.h>

int intlen(int a) {
int i = a;
int z = 0;

while (i != 0) {
i /= 10;
z++;
}

return z;
}

int intswap(int a) {
int i;
int z;
int c=0;

z = a;

i = intlen(a);

for (i;i>0;i--) {
c += z%10;
c *= 10;
z /= 10;
}

return c/10;

}

int main() {
printf("%d\n", intswap(123));
printf("%d\n", intswap(1232345));
return 0;
}
