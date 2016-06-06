#include <stdio.h>
#include <stdlib.h>

inline int x(int a) {
return a;
}

int main() {
int **a, x, y;
int i,j;

printf("matrix[i][j];\nenter value for i: ");
scanf("%d", &i);
printf("enter value for j: ");
scanf("%d", &j);

a = malloc(sizeof(int *)*i);
for (x=0;x<i;x++) a[x] = malloc(sizeof(int)*j);

for (x=0;x<i;x++) for (y=0;y<j;y++) {
printf("matrix[%d][%d] = ", x, y);
scanf("%d", &a[x][y]);
}

for (x=0;x<i;x++) free(a[x]);
free(a);

return 0;
}
