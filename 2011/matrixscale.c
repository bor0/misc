#include <stdio.h>

#define SCALE 5
#define MSIZEX 3
#define MSIZEY 2

void zoom_matrix(int *src, int *dst, int srcsizex, int srcsizey, int scale) {
	int r, c, i=0, j=0, tmpi, tmpj;

	for (r=0;r<srcsizex;r++,j+=scale,i=0) {
		for (c=0;c<srcsizey;c++) {
			tmpi = i+scale;
			for (i;i<tmpi;i++) for (tmpj=j;tmpj<j+scale;tmpj++) dst[scale*srcsizey*tmpj + i] = src[srcsizey*r + c];
		}
	}

}

int main() {
	int r, c, i=0, j=0, tmpi, tmpj;
	int m_orig[MSIZEX][MSIZEY] = {{ 1, 2 }, { 4, 5 }, { 7, 8 }};
	int m_scaled[SCALE*MSIZEX][SCALE*MSIZEY];

	zoom_matrix((int **)m_orig, (int **)m_scaled, MSIZEX, MSIZEY, SCALE);

	for (r=0;r<SCALE*MSIZEX;r++) {
		for (c=0;c<SCALE*MSIZEY;c++) {
			putchar('0'+m_scaled[r][c]);
		}
		putchar('\n');
	}

	return 0;
}