#include <stdio.h>

#define max 100

int main() {
int a[max][max];

a[0][0] = 123;

int *b = a;

printf("%d\n", *b);

return 0;

}
