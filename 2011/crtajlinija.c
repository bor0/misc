// ***************************
// CrtajLinija(A, B, boja);
// 14.08.2011
// Boro Sitnikovski
//

#include <windows.h>
#include <stdio.h>
#include <math.h>

#pragma comment(lib, "user32.lib")
#pragma comment(lib, "gdi32.lib")
#pragma comment(lib, "kernel32.lib")

// bug so A[0, 0], B[500, 501]

void CrtajLinija(HDC window, int x1, int y1, int x2, int y2, int color) {

	double dy, dx, y, newy, x;
	int k, tmp;

	//swap procedura za ako prvata tocka e podaleku od vtorata
	if (sqrt(x1*x1 + y1*y1) > (x2*x2 + y2*y2)) {
		tmp = y2;
		y2 = y1;
		y1 = tmp;
		tmp = x2;
		x2 = x1;
		x1 = tmp;
	}

	//inicijaliziraj dy/dx za slope
	dx = x2 - x1;
	dy = y2 - y1;

	for (x=x1,y=y1; x<x2; x++) {
		//kalkuliraj nov y
		newy = y1 + (dy) * (x - x1)/(dx);

		//ako rastojanieto od stariot i noviot y e pogolemo od 1
		if (newy - y >= 1) {

			//iscrtaj gi prvite polovini na tockite [x-1, y]
			for (k=y; k<(newy + y)/2; k++) {
				SetPixel(window, x-1, k, color);
				printf("0->%d, %d\n", (int)x-1, (int)k);
			}

			//iscrtaj gi vtorite polovini na tockite so [x, y]
			for (k; k<=newy; k++) {
				SetPixel(window, x, k, color);
				printf("1->%d, %d\n", (int)(x-1), (int)k);
			}
		}

		//prezemi nov y
		y = newy;

		//crtaj
		SetPixel(window, x, y, color);
		printf("2->%d, %d\n", (int)x, (int)y);
	}

}

int main() {
int x1, y1, x2, y2, color;
HDC dc;

//flushiraj gdi screen
InvalidateRect(0, 0, 0);

//zemi descriptor na desktop
dc = GetWindowDC(0);

scanf("%d %d %d %d %X", &x1, &y1, &x2, &y2, &color);
CrtajLinija(dc, x1, y1, x2, y2, color);
return 0;
}
