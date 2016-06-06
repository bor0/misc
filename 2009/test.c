#include <stdio.h>

struct {
unsigned int is_keyword : 1;
unsigned int is_extern : 1;
unsigned int is_static : 1;
} flags;

/*
Certain idioms appear frequently:
flags |= EXTERNAL | STATIC;
turns on the EXTERNAL and STATIC bits in flags, while
flags &= ~(EXTERNAL | STATIC);
turns them off, and
if ((flags & (EXTERNAL | STATIC)) == 0) ...
is true if both bits are off.
*/

int main() {
flags.is_keyword = 1;
printf("%d %d %d\n", flags.is_keyword, flags.is_extern, flags.is_static);
return 0;
}
