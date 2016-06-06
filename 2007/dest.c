//108kb requests in packets of 17kb and 28kb. how many packets of each type?

#include <stdio.h>

int main() {
int x,y;

for (x=-100;x<100;x++)
for (y=-100;y<100;y++)
if ((x*28 + y*17) == 108)
printf("(%d,%d)\n", x, y);

return 0;

}
