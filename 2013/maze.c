#include <stdio.h>

char mapa[100][100];
int visited[100][100] = { 0 };
int x, y;


int move(int i, int j) {
    if (i >= x || i < 0 || j >= y || j < 0) return 0;

    if (mapa[i][j] == '#') return 0;

    if (visited[i][j]) return 0;
    visited[i][j] = 1;

    if (mapa[i][j] == 'E' || move(i+1, j) || move(i-1, j) || move(i, j+1) || move(i, j-1)) {
        printf("(%d %d); ", i, j);
        return 1;
    }

    return 0;

}

int main() {
    int i, j, Sx, Sy;
    FILE *t = fopen("maze.txt", "r");

    if (!t) {
        return 0;
    }

    fscanf(t, "%d %d", &x, &y);

    for (i=0;i<x;i++) {
        fscanf(t, "%s", mapa[i]);
    }

    fclose(t);

    for (i=0;i<x;i++) {
        for (j=0;j<y;j++) {
            if (mapa[i][j] == 'S') {
                Sx = i; Sy = j; i = x; break;
            }
        }
    }

    if (move(Sx, Sy)) {
        printf("Ima pat!\n");
    }
    else {
        printf("Nema pat!\n");
    }

    return 0;

}
