//written by BoR0
//12.05.2007 - 17.05.2007

//1) Column scanning;
//2) Row scanning;
//3) Box scanning;
//4) Use elimination on column based on the results of 1);
//5) Use elimination on row based on the results of 2);
//6) Use elimination on box based on the results of 3);
//7) Ask user if he wants to save results to the file.

#include <stdio.h>

#define x1 x%3
#define y1 y%3

int main() {
int sudoku[9][9],possible[9][9][9], temp[9];
int coords[2][9], x,y,i,z,t; char a;

FILE *pFile = fopen("sudo.in", "r");

if (!pFile) {printf("Failure: I wan't sudo.in\n");return 0;}

for (y=0;y<9;y++)
for (x=0;x<9;x++) {
if (fscanf(pFile, "%d", &sudoku[y][x]) == -1) {
fclose(pFile);printf("Failure: I wan't a 9x9\n");return 0;}
if (sudoku[y][x] > 9 || sudoku[y][x] < 0) {
fclose(pFile);printf("Failure: Numbers allowed: 0-9\n");return 0;}
}

fclose(pFile);

for (y=0;y<9;y++)
for (x=0;x<9;x++)
for (i=0;i<9;i++) possible[y][x][i] = -1;

for (y=0;y<9;y++) for (x=0;x<9;x++)
if (sudoku[y][x] == 0) {

for (i=0;i<9;i++) temp[i]=0;

for (i=0;i<9;i++) {
// 1)
if (sudoku[i][x] != 0) temp[sudoku[i][x]-1]++;
// 1 ends.
// 2)
if (sudoku[y][i] != 0) temp[sudoku[y][i]-1]++;
// 2 ends.
}

// 3)
if (x1 == 0 && y1 == 0) {
if (sudoku[y1+y+1][x1+x+1] != 0) temp[sudoku[y1+y+1][x1+x+1]-1]++; 
if (sudoku[y1+y+1][x1+x+2] != 0) temp[sudoku[y1+y+1][x1+x+2]-1]++;
if (sudoku[y1+y+2][x1+x+1] != 0) temp[sudoku[y1+y+2][x1+x+1]-1]++;
if (sudoku[y1+y+2][x1+x+2] != 0) temp[sudoku[y1+y+2][x1+x+2]-1]++;
}
else if (x1 == 1 && y1 == 0) {
if (sudoku[y1+y+1][x1+x-2] != 0) temp[sudoku[y1+y+1][x1+x-2]-1]++; 
if (sudoku[y1+y+2][x1+x-2] != 0) temp[sudoku[y1+y+2][x1+x-2]-1]++;
if (sudoku[y1+y+1][x1+x] != 0) temp[sudoku[y1+y+1][x1+x]-1]++;
if (sudoku[y1+y+2][x1+x] != 0) temp[sudoku[y1+y+2][x1+x]-1]++;
}
else if (x1 == 2 && y1 == 0) {
if (sudoku[y1+y+1][x1+x-4] != 0) temp[sudoku[y1+y+1][x1+x-4]-1]++;
if (sudoku[y1+y+1][x1+x-3] != 0) temp[sudoku[y1+y+1][x1+x-3]-1]++;
if (sudoku[y1+y+2][x1+x-4] != 0) temp[sudoku[y1+y+2][x1+x-4]-1]++;
if (sudoku[y1+y+2][x1+x-3] != 0) temp[sudoku[y1+y+2][x1+x-3]-1]++;
}
else if (x1 == 0 && y1 == 1) {
if (sudoku[y1+y][x1+x+1] != 0) temp[sudoku[y1+y][x1+x+1]-1]++; 
if (sudoku[y1+y][x1+x+2] != 0) temp[sudoku[y1+y][x1+x+2]-1]++;
if (sudoku[y1+y-2][x1+x+1] != 0) temp[sudoku[y1+y-2][x1+x+1]-1]++;
if (sudoku[y1+y-2][x1+x+2] != 0) temp[sudoku[y1+y-2][x1+x+2]-1]++;
}
else if (x1 == 1 && y1 == 1) {
if (sudoku[y1+y-2][x1+x-2] != 0) temp[sudoku[y1+y-2][x1+x-2]-1]++; 
if (sudoku[y1+y-2][x1+x] != 0) temp[sudoku[y1+y-2][x1+x]-1]++;
if (sudoku[y1+y][x1+x-2] != 0) temp[sudoku[y1+y][x1+x-2]-1]++;
if (sudoku[y1+y][x1+x] != 0) temp[sudoku[y1+y][x1+x]-1]++;
}
else if (x1 == 2 && y1 == 1) {
if (sudoku[y1+y-2][x1+x-4] != 0) temp[sudoku[y1+y-2][x1+x-4]-1]++; 
if (sudoku[y1+y-2][x1+x-3] != 0) temp[sudoku[y1+y-2][x1+x-3]-1]++;
if (sudoku[y1+y][x1+x-4] != 0) temp[sudoku[y1+y][x1+x-4]-1]++;
if (sudoku[y1+y][x1+x-3] != 0) temp[sudoku[y1+y][x1+x-3]-1]++;
}
else if (x1 == 0 && y1 == 2) {
if (sudoku[y1+y-3][x1+x+1] != 0) temp[sudoku[y1+y-3][x1+x+1]-1]++; 
if (sudoku[y1+y-3][x1+x+2] != 0) temp[sudoku[y1+y-3][x1+x+2]-1]++;
if (sudoku[y1+y-4][x1+x+1] != 0) temp[sudoku[y1+y-4][x1+x+1]-1]++;
if (sudoku[y1+y-4][x1+x+2] != 0) temp[sudoku[y1+y-4][x1+x+2]-1]++;
}
else if (x1 == 1 && y1 == 2) {
if (sudoku[y1+y-4][x1+x-2] != 0) temp[sudoku[y1+y-4][x1+x-2]-1]++; 
if (sudoku[y1+y-3][x1+x-2] != 0) temp[sudoku[y1+y-3][x1+x-2]-1]++;
if (sudoku[y1+y-4][x1+x] != 0) temp[sudoku[y1+y-4][x1+x]-1]++;
if (sudoku[y1+y-3][x1+x] != 0) temp[sudoku[y1+y-3][x1+x]-1]++;
}
else if (x1 == 2 && y1 == 2) {
if (sudoku[y1+y-4][x1+x-4] != 0) temp[sudoku[y1+y-4][x1+x-4]-1]++; 
if (sudoku[y1+y-3][x1+x-4] != 0) temp[sudoku[y1+y-3][x1+x-4]-1]++;
if (sudoku[y1+y-4][x1+x-3] != 0) temp[sudoku[y1+y-4][x1+x-3]-1]++;
if (sudoku[y1+y-3][x1+x-3] != 0) temp[sudoku[y1+y-3][x1+x-3]-1]++;
}
// 3 ends.

z=0;
for (i=0;i<9;i++) if (temp[i] == 0) possible[y][x][z++] = i+1;

}

for (y=0;y<9;y++)
for (x=0;x<9;x++) {
if (possible[y][x][0] == -1) continue;

printf("(%d, %d): Available: ", x+1, y+1);
for (i=0;i<9;i++) {
if (possible[y][x][i] == -1) break;
printf("%d ", possible[y][x][i]);
}
if (possible[y][x][0] != -1 && possible[y][x][1] == -1)
sudoku[y][x] = possible[y][x][0];
printf("\n");
}

printf("The following information is based on row/column/box scanning\n\
where elimination is used and it gives the definite value.\n");

for (y=0;y<9;y++) {
// 4)
for (i=0;i<9;i++) temp[i]=0;
for (x=0;x<9;x++) {
if (possible[y][x][0] == -1) continue;
for (i=0;i<9;i++) {
if (possible[y][x][i] == -1) break;
temp[possible[y][x][i]-1]++;
coords[0][possible[y][x][i]-1] = x;
}
}
for (i=0;i<9;i++) if (temp[i] == 1) {
printf("(%d, %d): Definite value [%d]\n", coords[0][i]+1, y+1, i+1);
sudoku[y][coords[0][i]] = i+1;
}
// 4 ends.

// 5)
for (i=0;i<9;i++) temp[i]=0;
for (x=0;x<9;x++) {
if (possible[x][y][0] == -1) continue;
for (i=0;i<9;i++) {
if (possible[x][y][i] == -1) break;
temp[possible[x][y][i]-1]++;
coords[0][possible[x][y][i]-1] = x;
}
}
for (i=0;i<9;i++) if (temp[i] == 1) {
printf("(%d, %d): Definite value [%d]\n", y+1, coords[0][i]+1, i+1);
sudoku[coords[0][i]][y] = i+1;
}
// 5 ends.

}

// 6)
for (t=0;t<3;t++) for (z=0;z<3;z++) {
for (i=0;i<9;i++) temp[i]=0;
for (x=t*3;x<t*3+3;x++) for (y=3*z;y<3*z+3;y++)
for (i=0;i<9;i++) {
if (possible[x][y][i] == -1) break;
temp[possible[x][y][i]-1]++;
coords[0][possible[x][y][i]-1] = x;
coords[1][possible[x][y][i]-1] = y;
}
for (i=0;i<9;i++) if (temp[i] == 1) {
printf("(%d, %d): Definite value [%d]\n", sudoku[1][i]+1, sudoku[0][i]+1, i+1);
sudoku[coords[0][i]][coords[1][i]] = i+1;
}
}
// 6 ends.

// 7)
printf("\nSave results to 'sudo.in' ? [y/N] ");
scanf("%c", &a);

if (a == 'y' || a == 'Y') {

FILE *qFile = fopen("sudo.in", "w");

for (y=0;y<9;y++) {
for (x=0;x<9;x++)
fprintf(qFile, "%d ", sudoku[y][x]);
fprintf(qFile, "\n");
}

fclose(qFile);

printf("Saved.\n");

}
// 7 ends.

printf("Done.\n");

return 0;

}
