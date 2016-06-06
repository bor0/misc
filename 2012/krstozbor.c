#include <stdio.h>

#define X 4
#define Y 4

char matrica[5][5] = {{"BASD"}, {"OFED"}, {"RZBC"}, {"OGRO"}};
char word[] = "BORO";

void parse(int x, int y, int depth, int nasoka) {
	if (x < 0 || y < 0 || x >= X || y >= Y) return;
	if (matrica[x][y] != word[depth]) return;

	if (nasoka == 0) {
		printf("------------------\n");
	}

	printf("[%d] %d %d\n", depth, x, y);

	if (nasoka == 1) {
		parse(x-1, y, depth+1, 1);
	} else if (nasoka == 2) {
		parse(x, y-1, depth+1, 2);
	} else if (nasoka == 3) {
		parse(x+1, y, depth+1, 3);
	} else if (nasoka == 4) {
		parse(x, y+1, depth+1, 4);
	} else {
		parse(x-1, y, depth+1, 1);
		parse(x, y-1, depth+1, 2);
		parse(x+1, y, depth+1, 3);
		parse(x, y+1, depth+1, 4);
	}
}

int main() {
int x, y;

for (x=0;x<X;x++) {
for (y=0;y<Y;y++)
putchar(matrica[x][y]);
putchar('\n');
}

for (x=0;x<X;x++) for (y=0;y<Y;y++) parse(x, y, 0, 0);

return 0;
}
