// Boro Sitnikovski
// 23.02.2013
// Izmesano dynamic programming so (bruteforce) attempt na print na lokacii za shortest path

#include <stdio.h>

int visited[12][12], KposI, KposJ, AposI, AposJ;

char board[][9] = {
"********",
"*******K",
"********",
"********",
"********",
"**A*****",
"********",
"********"
};
int minmoves = 100;

int find_shortest_path(int i, int j, int depth) {
	if (i < 0 || j < 0 || i > 7 || j > 7) return 0;

	if (visited[i][j] != depth) return 0;

	if (i == AposI && j == AposJ) return 1;

	// knight moves
	if (find_shortest_path(i+1, j-2, depth + 1)) return 1;
	if (find_shortest_path(i+2, j+1, depth + 1)) return 1;
	if (find_shortest_path(i+2, j-1, depth + 1)) return 1;
	if (find_shortest_path(i+1, j+2, depth + 1)) return 1;

	if (find_shortest_path(i-1, j-2, depth + 1)) return 1;
	if (find_shortest_path(i-2, j-1, depth + 1)) return 1;
	if (find_shortest_path(i-1, j+2, depth + 1)) return 1;
	if (find_shortest_path(i-2, j+1, depth + 1)) return 1;

}

int main() {

	int i, j, k;

	for (i=0;i<8;i++) {
		for (j=0;j<8;j++) {
			visited[i][j] = 0;
			if (board[i][j] == 'K') {
				KposI = i;
				KposJ = j;
				//break;
			}
			else if (board[i][j] == 'A') {
				AposI = i;
				AposJ = j;
			}
		}
	}

	printf("%d, %d\n", KposI, KposJ);
	
	for (k=0;k<100;k++) {
		for (i=0;i<8;i++) {
			for (j=0;j<8;j++) {
				if (i == KposI && j == KposJ || visited[i][j] != 0) {
					if (j>=2 && (visited[i+1][j-2] == 0 || visited[i+1][j-2] > visited[i][j]+1) ) visited[i+1][j-2] = visited[i][j] + 1;
					if (visited[i+2][j+1] == 0 || visited[i+2][j+1] > visited[i][j] + 1) visited[i+2][j+1] = visited[i][j] + 1;
					if (j>=1 && (visited[i+2][j-1] == 0 || visited[i+2][j-1] > visited[i][j] + 1) ) visited[i+2][j-1] = visited[i][j] + 1;
					if (visited[i+1][j+2] == 0 || visited[i+1][j+2] > visited[i][j] + 1) visited[i+1][j+2] = visited[i][j] + 1;
					if (j>=2 && i>=1 && (visited[i-1][j-2] == 0 || visited[i-1][j-2] > visited[i][j] + 1)) visited[i-1][j-2] = visited[i][j] + 1;
					if (j>=1 && i>=2 && (visited[i-2][j-1] == 0 || visited[i-2][j-1] > visited[i][j] + 1)) visited[i-2][j-1] = visited[i][j] + 1;
					if (i>=1 && (visited[i-1][j+2] == 0 || visited[i-1][j+2] > visited[i][j]+1)) visited[i-1][j+2] = visited[i][j] + 1;
					if (i>=2 && (visited[i-2][j+1] == 0 || visited[i-2][j+1] > visited[i][j]+1)) visited[i-2][j+1] = visited[i][j] + 1;
				}
			}
		}
	}
	
	visited[KposI][KposJ] = 0;
	visited[AposI][AposJ] = 0;
	//printf("%d\n", minmoves);

	for (i=0;i<8;i++) {
		for (j=0;j<8;j++) {
			printf("%5d ", visited[i][j]);
		}
		putchar('\n');
	}

	find_shortest_path(KposI, KposJ, 0);

	return 0;

}