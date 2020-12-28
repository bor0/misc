#include <stdio.h>

FILE *pFile;

int writeresults(int i) {

pFile = fopen("zgradi.out", "w");
fprintf(pFile, "%d", i);
fclose(pFile);

return 0;

}

int main() {

int x,y,x1,y1;
int total=0;

pFile = fopen("zgradi.in", "r");

fscanf(pFile, "%d%d", &y1, &x1);
int zgradi[x1][y1];

for (y=0;y<y1;y++)
for (x=0;x<x1;x++)
fscanf(pFile, "%d", &zgradi[x][y]);

fclose(pFile);

for (y=y1-2;y>=0;y--) {
for (x=0;x<x1;x++) if ((zgradi[x][y] == 0) && (zgradi[x-1][y] != 0)) total++;
if (total != 0) break;
}

writeresults(total);

return 0;

}
