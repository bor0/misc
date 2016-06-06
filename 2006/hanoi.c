#include <stdio.h>

int p = 0;

int Solve(int n, int src, int aux, int dest) {

if (!n) return 0;

Solve(n-1, src, dest, aux);
printf("Poteg %d:\tPremesti od %d na %d\n", ++p, src, dest);
Solve(n-1, aux, src, dest);

return 0;

}

int main() {
int n;

printf("Kolku diskovi: ");
scanf("%d", &n);

Solve(n, 1, 2, 3);
printf("Zavrseno vo %d potezi.\n", p);

return 0;

}
