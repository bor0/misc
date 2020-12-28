#include <stdio.h>

int matrica[80][80];

int procitajmat(int x, int y) { // 2x2 cita ^^
int a = matrica[x][y];
int b = matrica[x][y+1];
int c = matrica[x+1][y];
int d = matrica[x+1][y+1];

if ((a == b) || (a == c) || (a == d) || (b == c) || (b == d) || (c == d)) return 0;

return 1;

}

int main() {
int x,y,z,xy;

FILE *pFile = fopen("plocki.in", "r");

fscanf(pFile, "%d", &xy);

for (x=0;x<xy;x++)
for (y=0;y<xy;y++) fscanf(pFile, "%d", &matrica[x][y]);

fclose(pFile);

z = 0;

for (x=0;x<(xy-1);x++)
for (y=0;y<(xy-1);y++) {
z += procitajmat(x, y);
}

pFile = fopen("plocki.out", "w");
fprintf(pFile, "%d", z);
fclose(pFile);

return 0;

}
