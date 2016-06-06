#include <stdio.h>

int *laser(int a) {
static int b;

b = a;

return &b;
}

int main() {

printf("%X -> %d\n", laser(3), *laser(3));
return 0;
}
