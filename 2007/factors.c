#include <stdio.h>

int main() {
int n,i;
scanf("%d", &n);

printf("%d = ", n);

for (i=2;(i<n+1) && (n != 1);i++) {

if (n%i == 0) {
n/=i;
printf("%d * ", i);
i--;
}

}

printf("1\n");

return 0;

}
