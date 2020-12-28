#include <string>
#include <vector>
#include <iostream>
using namespace std;

class Minesweeper {
	public:
	char **array; int max;

	bool getsize(int m, int n) {
		if (m>=0 && m<max && n>=0 && n<max) return 1;
		return 0;
	}

	void getmines(char **a, int x, int y) {
		char c='0';
		if (getsize(x-1,y-1) && a[x-1][y-1] == 'x') c++;
		if (getsize(x, y-1) && a[x][y-1] == 'x') c++;
		if (getsize(x-1, y) && a[x-1][y] == 'x') c++;
		if (getsize(x-1, y+1) && a[x-1][y+1] == 'x') c++;
		if (getsize(x+1, y-1) && a[x+1][y-1] == 'x') c++;
		if (getsize(x, y+1) && a[x][y+1] == 'x') c++;
		if (getsize(x+1, y) && a[x+1][y] == 'x') c++;
		if (getsize(x+1, y+1) && a[x+1][y+1] == 'x') c++;
		a[x][y] = c;
		return;
	}

	string solve(string minefield, int n) {
		int i,j;
		max = n; array = new char *[n];
		for (i=0;i<n;i++) array[i] = new char[n];
		for (i=0;i<n;i++) for (j=0;j<n;j++) array[i][j] = minefield[i*n+j];
		for (i=0;i<n;i++) for (j=0;j<n;j++) if (array[i][j] != 'x') getmines(array, i, j);
		for (i=0;i<n;i++) for (j=0;j<n;j++) minefield[i*n+j] = array[i][j];
		for (i=0;i<n;i++) free(array[i]);
		free(array);
		return minefield;
	}
};

int main() {
Minesweeper A;
cout << A.solve("x.x...x.x", 3);
return 0;
}