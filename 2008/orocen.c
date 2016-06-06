#include <stdio.h>

int main() {
float a, b, c, d;
int i,j;

printf("Vnesi poceten vlog: ");
scanf("%f", &a);
d=a;

printf("Vnesi kamatna stapka: ");
scanf("%f", &c);

printf("Vnesi kolku meseci: ");
scanf("%d", &j);

for (i=0;i<j;i++) {
b = a*c;
a += b;
printf("%d: %f\n", i+1, b);
}

printf("- %.f (%.f mesecno) - %.f (%.f mesecno)\n", a, a/j, a-d, (a-d)/j);

return 0;
}
