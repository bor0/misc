#include <stdio.h>

//rekurziven glupav floodfill algoritam
//poradi koj sto ne dobi nagrada na natprevarite(
//15.05.2009

int mat[100][100], a,i,j,x,y,c=0;

void puni(int p, int q) {

if (p>a || q>a || p<0 || q<0 || mat[p][q] == 1) return;

if (mat[p][q] == 0) {
c++;
mat[p][q] = 2;
puni(p+1,q);
puni(p,q+1);
puni(p-1,q);
puni(p,q-1);
}

}

int main() {
FILE *pFile = fopen("pikado.in", "r");

fscanf(pFile, "%d", &a);

for (i=0;i<a;i++)
for (j=0;j<a;j++)
fscanf(pFile, "%d", &mat[i][j]);
fscanf(pFile, "%d %d", &x, &y);
fclose(pFile);

x--; y--;

/*for (i=0;i<a;i++) {
for (j=0;j<a;j++)
printf("%d ", mat[i][j]);
printf("\n");
}
printf("---------------\n");*/

a--; puni(x, y); a++;

/*for (i=0;i<a;i++) {
for (j=0;j<a;j++) {
if (mat[i][j] == 2) c++;
printf("%d ", mat[i][j]);
}
printf("\n");
}*/

printf("%d\n", c);

return 0;

}
