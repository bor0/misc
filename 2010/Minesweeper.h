class Minesweeper {
	private:

	struct byteinfo {
		/*
		 * Value: 0, Code: Mine
		 * Value: n=(1,8), Code: Surrounded by n mines
		 * Value: 9, Code: Opened, empty slot
		 * Value: 10, Code: Non-opened slot
		 */
		unsigned char value:4;
		unsigned char reveal:1;
		unsigned char reserved:3; // for future use
	} **array;

	int n, i, j, mines, victory;

	bool GetSize(int a, int b) { return (a>=0 && a<n && b>=0 && b<n)?1:0; }

	void GetMines(int x, int y) {
		char c = 0;
		if (array[x][y].value == 0) return;
		if (GetSize(x-1,y-1) && !GetField(x-1, y-1, 1)) c++;
		if (GetSize(x, y-1) && !GetField(x, y-1, 1)) c++;
		if (GetSize(x-1, y) && !GetField(x-1, y, 1)) c++;
		if (GetSize(x-1, y+1) && !GetField(x-1, y+1, 1)) c++;
		if (GetSize(x+1, y-1) && !GetField(x+1, y-1, 1)) c++;
		if (GetSize(x, y+1) && !GetField(x, y+1, 1)) c++;
		if (GetSize(x+1, y) && !GetField(x+1, y, 1)) c++;
		if (GetSize(x+1, y+1) && !GetField(x+1, y+1, 1)) c++;
		if (c == 0) array[x][y].value = 9;
		else array[x][y].value = c;
		return;
	}

	public:

	Minesweeper() {
		srand(time(NULL));
	}

	unsigned char GetField(int x, int y, int reveal=0) {
		if (reveal) return (unsigned char)array[x][y].value;
		if (!array[x][y].reveal) return 10;
		return (unsigned char)array[x][y].value;
	}

	bool IsVictory() {
		return (victory == (n*n - mines));
	}

	int GetMines() {
		return mines;
	}
	
	int GetField() {
		return n;
	}

	int GenerateField(int n, int mines) {
		if (n*n <= mines || n < 1 || mines < 1) return -1;

		victory = 0;

		array = new struct byteinfo *[n];
		if (!array) return -1;

		this->n = n;

		for (i=0;i<n;i++) { array[i] = new struct byteinfo[n]; if (!array[i]) return -1; }
		for (i=0;i<n;i++) for (j=0;j<n;j++) { array[i][j].value = 10; array[i][j].reveal = 0; }

		this->mines = mines;

		while(mines) {
			i = rand()%n; j = rand()%n;
			if (array[i][j].value == 0) continue;
			array[i][j].value = 0; mines--;
		}

		for (i=0;i<n;i++) for (j=0;j<n;j++) GetMines(i, j);

		return 0;		
	}
	
	void DestroyField() {
		for (i=0;i<n;i++) free(array[i]);
		free(array);
	}

	int PlayMove(int x, int y) {
		if (!GetSize(x, y)) return -1;
		if (!array[x][y].reveal) victory++; array[x][y].reveal = 1;
		if (GetField(x, y, 1) == 0) return 0;
		if (GetSize(x-1,y-1) && GetField(x-1, y-1, 1) && (!array[x-1][y-1].reveal)) { array[x-1][y-1].reveal = 1; victory++; }
		if (GetSize(x, y-1) && GetField(x, y-1, 1) && (!array[x][y-1].reveal)) { array[x][y-1].reveal = 1; victory++; }
		if (GetSize(x-1, y) && GetField(x-1, y, 1) && (!array[x-1][y].reveal)) { array[x-1][y].reveal = 1; victory++; }
		if (GetSize(x-1, y+1) && GetField(x-1, y+1, 1) && (!array[x-1][y+1].reveal)) { array[x-1][y+1].reveal = 1; victory++; }
		if (GetSize(x+1, y-1) && GetField(x+1, y-1, 1) && (!array[x+1][y-1].reveal)) { array[x+1][y-1].reveal = 1; victory++; }
		if (GetSize(x, y+1) && GetField(x, y+1, 1) && (!array[x][y+1].reveal)) { array[x][y+1].reveal = 1; victory++; }
		if (GetSize(x+1, y) && GetField(x+1, y, 1) && (!array[x+1][y].reveal)) { array[x+1][y].reveal = 1; victory++; }
		if (GetSize(x+1, y+1) && GetField(x+1, y+1, 1) && (!array[x+1][y+1].reveal)) { array[x+1][y+1].reveal = 1; victory++; }
		return 1;
	}

	~Minesweeper() {
		DestroyField();
	}
	
};