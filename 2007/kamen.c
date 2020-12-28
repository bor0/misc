#include <stdio.h>

// SITNIKOVSKI BORO 22.04.2007

unsigned char alpha[] = { '0', '1', '2', '3', '4', '5', '6',\
'7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',\
'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',\
'V', 'W', 'X', 'Y', 'Z' };

int main() {
int i,y,x;
char boro[32000];

FILE *pFile = fopen("kamen.in", "r");
FILE *qFile = fopen("kamen.out", "w");

fscanf(pFile, "%d", &x);
fscanf(pFile, "%s", &boro);
x%=36; if (x<0) x+=36;

for (i=0;;i++) {
if (boro[i] == 0) break;
y = boro[i];

if (y >= 65 && y <= 90) y-=55;
else y-=48;

y+=x; y%=36;
boro[i] = alpha[y];

}

fprintf(qFile, "%s\n", boro);

fclose(qFile);
fclose(pFile);

return 0;

}