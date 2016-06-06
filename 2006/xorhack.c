#include <stdio.h>

int main() {
int a=8;
int b=6;

a^=b; b^=a; a^=b;

printf("a=%d, b=%d\n", a,b);

return 0;

}
