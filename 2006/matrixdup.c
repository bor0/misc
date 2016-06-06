#include <windows.h>

#define xrow 120
#define yrow 120
#define p    4

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {
int i[xrow][yrow];
int z[p*xrow][p*yrow];

int x,y,j,k;

HDC Moo = GetDC(0);

for (x=0;x<xrow;x++)
for (y=0;y<yrow;y++) {
i[x][y] = GetPixel(Moo, x, y);
}

for (x=0;x<xrow;x++)
for (y=0;y<yrow;y++)
for (j=0;j<p;j++)
for (k=0;k<p;k++)
z[p*x+j][p*y+k] = i[x][y];

MessageBox(0,"Get ready for a huge zoom! =)","By BoR0",MB_ICONINFORMATION);

for (x=0;x<p*xrow;x++)
for (y=0;y<p*yrow;y++) {
SetPixel(Moo, x, y, z[x][y]);
}

ExitProcess(0);

}
