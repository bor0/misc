#include <stdio.h>

int main() {
int i;

for (i=8;i>0;i--) {
if (i%2 == 0) printf("A%d\t\tC%d\t\tE%d\t\tG%d\n", i, i, i, i);
else printf("\tB%d\t\tD%d\t\tF%d\t\tH%d\n", i, i, i, i);
}

return 0;

}
