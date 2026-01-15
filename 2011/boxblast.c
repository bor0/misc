#include <stdio.h>

// Box (Bubble) Blast! v1.0 by Boro Sitnikovski
// 28.03.2011
// Na Diksi omilenata igra :)

#define EMPTY 0
#define RED 1
#define YELLOW 2
#define GREEN 3
#define BLUE 4

int board[5][6];
int i, j;

int board_go(int x, int y, int direction) {

	if (x<0 || x>4 || y<0 || y>5) return 0;

	if (board[x][y] > 1) board[x][y]--;

	else if (board[x][y] == 1) {
		board[x][y]--;
		board_go(x-1, y, 0);
		board_go(x+1, y, 1);
		board_go(x, y+1, 2);
		board_go(x, y-1, 3);
	}

	else if (board[x][y] == 0) {
		if (direction == 0) board_go(x-1, y, 0);
		else if (direction == 1) board_go(x+1, y, 1);
		else if (direction == 2) board_go(x, y+1, 2);
		else if (direction == 3) board_go(x, y-1, 3);
		else return 0;
	}

	return 1;
}

void board_print() {

	for (i=0;i<6;i++) {

		for (j=0;j<5;j++) printf("%d ", board[j][i]);
		putchar('\n');

	}

	return;
}

int board_check() {

	int s=0;

	for (i=0;i<6;i++) for (j=0;j<5;j++) if (board[j][i] != 0) return 0;

	return 1;
}

int main() {

	FILE *t = fopen("board.txt", "r");
	int k;

	if (!t) return 0;
	fscanf(t, "%d", &k);

	for (i=0;i<6;i++) for (j=0;j<5;j++) {

		fscanf(t, "%d", &board[j][i]);

		if (board[j][i] > 4 || board[j][i] < 0) {
			printf("Invalid value in table!\n");
			fclose(t);
			return 0;
		}

	}

	fclose(t);
	board_print();

	while (k) {

		scanf("%d%d", &i, &j);
		board_go(i, j, 4);

		if (board_check()) {
			printf("You win!");
			return 1;
		}

		board_print();
		k--;

	}

	printf("You lose!");

	return 0;
}