#include <windows.h>

HDC Moo=0;
HDC Moo2=0;

int moo[200][200];
int moo2[200][200];
int i=0;
int j=0;

int inversem(int src[200][200], int dest[200][200], int elements) {
int i,j;

for (i=0; i<=elements; i++) for(j=0;j<=elements;j++) 
dest[elements-i-1][elements-j-1] = ~src[i][j];

return 0;

}

 
int PASCAL WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR 
lpszCmdLine, int nCmdShow)
{
Sleep(5000);
Moo=GetWindowDC(FindWindow(0, "Winamp Playlist Editor"));
Moo2=GetWindowDC(GetDesktopWindow());

for (i=0;i<100;i++) for (j=0;j<100;j++) moo[i][j] = GetPixel(Moo, i, j);
MessageBox(0,0,0,0);
Sleep(3000);

inversem(moo, moo2, 100);

for (i=0;i<100;i++) for (j=0;j<100;j++) SetPixel(Moo2, i, j, moo2[i][j]);

return 0;

}

