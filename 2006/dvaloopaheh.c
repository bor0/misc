#include <stdio.h>

int main() {
int x, y, n;
scanf("%d", &n);

for (y=1;y<n+1;y++) {
for (x=0;x<y;x++) printf("%d ", x+1);
printf("\n");
}
for (n;n>=1;n--) {
for (x=0;x<n;x++) printf("%d ", x+1);
printf("\n");
}

return 0;

}
