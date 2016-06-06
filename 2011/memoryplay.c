#include <stdio.h>

int main() {
int x, y;
printf("%X\n", (int)&x);
scanf("%X", &y);

*(int *)y = 3;
printf("%X", x);
return 0;
}
