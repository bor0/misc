#include <stdio.h>

int main() {
int i,j; char c;

for (i=8;i>0;i--) {
for (j=1,c='A';j<=8;j++,c++)
if (((j+i)%2)==0) printf("  ");
else printf("%c%d", c, i);
printf("\n\n");
}

return 0;

}
