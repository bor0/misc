#include <stdio.h>

int greska() {
printf("Error found in Sudoku. This is not a valid Sudoku solution.\n");
exit(0);
}

int main() {

FILE *pFile;
int area,x,y,i;

pFile = fopen("sudoku.in", "r");

fscanf(pFile, "%d", &area);

int sudoku[area][area];

for (x=0;x<area;x++)
for (y=0;y<area;y++)
fscanf(pFile, "%d", &sudoku[x][y]);

fclose(pFile);

int sudokutest[area];

for (x=0;x<area;x++) {
for (i=0;i<area;i++) sudokutest[i]=1;
for (y=0;y<area;y++) {
sudokutest[sudoku[x][y] - 1]--;
if (sudokutest[sudoku[x][y] - 1] < 0) greska();
}
}

for (x=0;x<area;x++) {
for (i=0;i<area;i++) sudokutest[i]=1;
for (y=0;y<area;y++) {
sudokutest[sudoku[y][x] - 1]--;
if (sudokutest[sudoku[x][y] - 1] < 0) greska();
}
}

printf("No error found. This is a valid Sudoku solution.\n");

return 0;

}
