#include <stdio.h>

int golemina=0;

int *presek(int a[], int b[], int c, int d) {
int *m = malloc(sizeof(int)*c);
int x,y,h=0;

for (x=0;x<c;x++)
for (y=0;y<d;y++) if (a[x] == b[y]) {m[h++] = a[x]; a[x] = -1;}
golemina = h;

return m;
}

int main() {
int a,b,x,y;
int **m, *c, *tmp;

printf("Vnesi m i n soodvetno: ");
scanf("%d%d", &a,&b);

m = malloc(sizeof(int)*a);
for (x=0;x<b;x++)
m[x] = malloc(sizeof(int)*b);

if (a<=1 || b<=1) return 0;

for (x=0;x<a;x++)
for (y=0;y<b;y++) {
printf("Vnesi m[%d][%d]: ", x,y);
scanf("%d", &m[x][y]);
}

c = malloc(sizeof(int)*b); for (y=0;y<b;y++) c[golemina++] = m[0][y];
for (x=1;x<a;x++) { tmp = presek(m[x], c, b, golemina); free(c); c = tmp; }

if (!golemina) printf("Ne postojat takvi broevi.");
else {
if (golemina == 1) printf("\n\nBrojot e: ");
else printf("Broevite se: \n");
for (y=0;y<golemina;y++) printf("%d ", c[y]);
}

printf("\n");

for (x=0;x<b;x++) free(m[x]); free(m); free(c);

return 0;

}
