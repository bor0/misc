#include <stdio.h>
#define MAX 256

int x1[MAX],x2[MAX]; double x3[MAX];

int dropki(int broj) {
int x,i,z,j,c;
double myfloat;

c=0;

for (x=0;x<=broj;x++)
for (i=1;i<=broj;i++) {

myfloat = x;
myfloat/= i;

if (myfloat >= 1) continue;
for (z=0;z<c;z++) if (myfloat == x3[z]) {
z=8020;
break;
}

if (z==8020) continue;

x1[c] = x;
x2[c] = i;
x3[c] = myfloat;

c++;

}

x1[c]=1;
x2[c]=1;
x3[c]=1;
c++;

for (x=0;x<c;x++)
for (i=0;i<c;i++) {
if (x3[x] < x3[i]) {
myfloat = x3[i];
j = x2[i];
z = x1[i];

x3[i]=x3[x];
x3[x]=myfloat;

x2[i]=x2[x];
x2[x]=j;

x1[i]=x1[x];
x1[x]=z;

}
}

return c;

}


int main() {

int x,y,z;

scanf("%d", &z);

y = dropki(z);

for (x=0;x<y;x++) printf("%d / %d = %f\n", x1[x], x2[x], x3[x]);

printf("For z=%d we have %d members.\n", z, y);

return 0;

}
