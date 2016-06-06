#include <stdio.h>
//#include <random.h>
//#include <time.h>

#define MAX 20

int main() {
	char map[MAX][MAX] = { 0 };
	char command;
	int i,j,xloc,yloc,bombs=20,hp=100;

	srand(time(NULL));

	for (i=0;i<MAX;i++) {
		map[i][0] = '#';
		map[0][i] = '#';
		map[MAX-1][i] = '#';
		map[i][MAX-1] = '#';
	}

	while (bombs != 0) {
		i = rand()%MAX; j = rand()%MAX;
		if (map[i][j] == 0) {
			map[i][j] = rand()%2?'.':'-';
			bombs--;
		}
	}
	
	while (1) {
		xloc = rand()%MAX; yloc = rand()%MAX;
		if (map[xloc][yloc] == 0) break;
	}
	
	map[xloc][yloc] = '@';

	system("cls");
	printf("Izedi gi site crvcinja\nza da ti kazam nesto\nHP: %d\n", hp);
	for (i=0;i<MAX;i++) {
		for (j=0;j<MAX;j++) putchar(map[j][i]);
		putchar('\n');
	}
	
	while ((command = getch()) != '.' && command != 27) {

		if (command == 75 && map[xloc-1][yloc] != '#') { //levo
			if (map[xloc-1][yloc] == '-') { hp--; bombs++; }
			else if (map[xloc-1][yloc] == '.') { hp++; bombs++; }
			map[xloc-1][yloc] = '@'; map[xloc][yloc] = 0;
			xloc--;
		}
		else if (command == 72 && map[xloc][yloc-1] != '#') { //gore
			if (map[xloc][yloc-1] == '-') { hp--; bombs++; }
			else if (map[xloc][yloc-1] == '.') { hp++; bombs++; }
			map[xloc][yloc-1] = '@'; map[xloc][yloc] = 0;
			yloc--;
		}
		else if (command == 77 && map[xloc+1][yloc] != '#') { //desno
			if (map[xloc+1][yloc] == '-') { hp--; bombs++; }
			else if (map[xloc+1][yloc] == '.') { hp++; bombs++; }
			map[xloc+1][yloc] = '@'; map[xloc][yloc] = 0;
			xloc++;
		}
		else if (command == 80 && map[xloc][yloc+1] != '#') { //dole
			if (map[xloc][yloc+1] == '-') { hp--; bombs++; }
			else if (map[xloc][yloc+1] == '.') { hp++; bombs++; }
			map[xloc][yloc+1] = '@'; map[xloc][yloc] = 0;
			yloc++;
		}
		
		system("cls");
		if (bombs == 20) printf("!!!NIKOLCE  E GAY!!!\n\007");
		else printf("Izedi gi site crvcinja\nza da ti kazam nesto\nHP: %d\n", hp);
		for (i=0;i<MAX;i++) {
			for (j=0;j<MAX;j++) putchar(map[j][i]);
			putchar('\n');
		}

	}

	return 0;
}