#include <stdio.h>

int akerman(int i, int j) {
if (i==0) return j + 1;
if (j==0) return akerman(i-1, 1);
if (i>0 && j>0) return akerman(i-1, akerman(i, j-1));

return 0;

}

int main() {
int a,b;

scanf("%d%d", &a, &b);

printf("%d\n", akerman(a,b));

return 0;
}
