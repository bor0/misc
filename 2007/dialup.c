#include <stdio.h>

// SITNIKOVSKI BORO 22.04.2007

int tarifa,h,m,d;

int clockincmin() {

m++;

if (h==24) h = 0;
if (m==60) { m = 0; h++; }
if (h==24) h = 0;

if (h>=7 && h<19) {
tarifa+=10;
if (h==7 && m==0) tarifa-=5;
}
else {
if (h==19 && m==0) tarifa+=5;
tarifa+=5;
}

return 0;
}

int main() {
char boro[6];
int i,y;
FILE *pFile = fopen("dialup.in", "r");
FILE *qFile = fopen("dialup.out", "w");

fscanf(pFile, "%d", &i);
tarifa = 0;

for (i=i;i>0;i--) {

fscanf(pFile, "%s%d", &boro, &d);

for (y=0;y<6;y++) boro[y]-=48;
h = boro[0]*10 + boro[1]%10;
m = boro[3]*10 + boro[4]%10;

for (y=0;y<d;y++) clockincmin();

}

fprintf(qFile, "%d\n", tarifa);
fclose(pFile);
fclose(qFile);

return 0;

}