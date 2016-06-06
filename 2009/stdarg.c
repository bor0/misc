#include <stdio.h>
#include <stdarg.h>

void printint(int a, ...) {
va_list args; int i;

va_start(args, a);
for (i=0;i<a;i++)
printf("%d\n", va_arg(args, int));

va_end(args);
}

int main() {
printint(4,1,2,3,4);
return 0;
}
