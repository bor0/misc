#include <iostream>
#include <time.h>
#include "Minesweeper.h"
using namespace std;

int PrintField(Minesweeper *x, bool print=0) {
	int counter = x->GetMines(), n = x->GetField();
	char c;
	for (int i=0;i<n;i++) {
		for (int j=0;j<n;j++) {
			c = x->GetField(i, j, print);
			if (c == 0) c = 'X';
			else if (c == 9) c = 'N';
			else if (c == 10) { c = '?'; counter--; }
			else c+='0';
			cout << c << " ";
		}
		cout << endl;
	}
	return counter;
}

int kill(Minesweeper *x, char *exitcode) {
	cout << exitcode << endl;
	delete x;
	return 0;
}

int main() {

	int x,y;
	Minesweeper *Minefield;

	cout << "Textual Minesweeper v1.0 by BoR0.  Written 11.04.2010." << endl;
	cout << "Input x(the field size x*x) and y(the number of bombs): ";
	cin >> x >> y;

	Minefield = new Minesweeper;

	if (Minefield->GenerateField(x, y) == -1) return kill(Minefield, "Error in generating field.  Please check your parameters.");

	PrintField(Minefield);

	cout << endl << "Input x and y respectively to play: ";
	cin >> x >> y;

	while (!Minefield->IsVictory() && x != -1 && y != -1) {

		if (Minefield->PlayMove(x, y) == 0) {
			PrintField(Minefield, 1);
			return kill(Minefield, "You stepped on a mine!  Bye!");
		}

		PrintField(Minefield);

		cout << endl << "Input x and y respectively to play: ";
		cin >> x >> y;
	}

	return kill(Minefield, "You won the game!  Grats!");
}
