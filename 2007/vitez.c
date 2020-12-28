#include <stdio.h>

// SITNIKOVSKI BORO 28.04.2007

int main() {
int x,y,i;
float temp;
scanf("%d", &i);
int vitezi[i]; int vitez[i]; float prihod[i];

for (x=0;x<i;x++) {
scanf("%d%f", &vitez[x], &prihod[x]);
vitezi[x] = x+1;
}

for (x=0;x<i;x++) prihod[x] = vitez[x] * prihod[x] / 100;

for (x=0;x<i;x++)
for (y=0;y<i;y++)
if (prihod[x] > prihod[y]) {
temp = prihod[y];
prihod[y] = prihod[x];
prihod[x] = temp;

temp = vitezi[y];
vitezi[y] = vitezi[x];
vitezi[x] = temp;
}

for (x=0;x<i;x++) if (prihod[x+1] != prihod[x]) break;

for (i=0;i<=x;i++) printf("%d\n", vitezi[i]);

return 0;

}
