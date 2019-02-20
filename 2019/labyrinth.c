#include <stdio.h>

/*
$ cat labyrinth.in 
6 6
.S...E
.#.##.
.#....
.#.##.
.####.
......
$ cat labyrinth2.in
6 6
.S.#E.
.#.##.
.#....
.#.##.
.####.
......
*/

// This program checks if we can go from S to E in a sequence of (1, 2, 3) steps, rotatingly.
// E.g. first move is 1 step, second move is 2 steps, third move is 3 steps, fourth move is 1 step, in general kth move is (k-1)%3+1 steps

char matrica[100][100];

// looks like DP
int visited[100][100];
int w, h;

#define INFINITY 100000

int ismovementvalid(int i, int j) {
	if (i < 0 || j < 0) {
		return 0;
	}

	if (i >= w || j >= h) {
		return 0;
	}

	if (matrica[i][j] == '#') {
		return 0;
	}

	return 1;
}

int pathvisited[100][100];

int pathexistshelper(int i, int j, int next_i, int next_j, int moves) {
	if (pathvisited[i][j]) {
		return 0;
	}

	if (moves < 0) {
		return 0;
	}

	pathvisited[i][j] = 1;

	if (!ismovementvalid(i,j)) {
		return 0;
	}

	if (i == next_i && j == next_j) {
		return 1;
	}

	moves--;

	return pathexistshelper(i-1,j,next_i,next_j,moves)
		|| pathexistshelper(i,j-1,next_i,next_j,moves)
		|| pathexistshelper(i+1,j,next_i,next_j,moves)
		|| pathexistshelper(i,j+1,next_i,next_j,moves);
}

int pathexists(int i, int j, int next_i, int next_j, int moves) {
	for (int i=0;i<100;i++) {
		for (int j=0;j<100;j++) {
			pathvisited[i][j] = 0;
		}
	}

	return pathexistshelper(i, j, next_i, next_j, moves);
}

int makemovement(int move, int count, int i, int j) {
	int k;
	char woot[100];
	for (k = 0; k < count; k++) woot[k] = ' ';
	woot[k] = '\0';
	int dx, dy;

	move = (move % 3) + 1;

	if (visited[i][j] > count) {
		visited[i][j] = count;
	} else if (visited[i][j]) {
		return visited[i][j];
	}

	if (matrica[i][j] == 'E') {
		return visited[i][j] + 1;
	}

	for (dx = -1; dx <= 1; dx++) {
		for (dy = -1; dy <= 1; dy++) {
			if (dy == 0 && dx == 0) {
				continue;
			}

			if (! ismovementvalid(i + dx*move, j + dy*move)) {
				continue;
			}

			if (! pathexists(i, j, i + dx*move, j + dy*move, move)) {
				continue;
			}

			makemovement(move, count + 1, i + dx*move, j + dy*move); 
		}
	}

	return 0;
}

int main(int argc, char **argv) {
	int cur_i, cur_j, tar_i, tar_j;
	FILE *in;

	for (int i=0;i<100;i++) {
		for (int j=0;j<100;j++) {
			visited[i][j] = INFINITY;
		}
	}

	if (2 != argc) {
		printf("Usage: %s <file.in>\n", argv[0]);
		return 0;
	}

	in = fopen(argv[1], "r");

	if (! in) {
		printf("Input file not found\n");
		return 0;
	}

	fscanf(in, "%d%d", &h, &w);

	for (int i = 0; i < h; i++) {
		char woot[100];
		fscanf(in, "%s", woot);
		for (int j = 0; j < w; j++) {
			matrica[i][j] = woot[j];
			if ('S' == matrica[i][j]) {
				cur_i = i;
				cur_j = j;
			}
			if ('E' == matrica[i][j] ) {
				tar_i = i;
				tar_j = j;
			}
		}
	}

	fclose(in);

	visited[cur_i][cur_j] = 0;

	makemovement(0, 0, cur_i, cur_j);

	if (visited[tar_i][tar_j] == INFINITY) {
		printf("NO\n");
	} else {
		printf("%d\n", visited[tar_i][tar_j]);
	}

	return 0;
}
