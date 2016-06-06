#include <windows.h>

HDC Moo=0;
int moo[1024*768];
int moo2[1024*768];
int i=0;
int j=0;
int z=0;

int inversem(int *src, int *dest, int elements) {
int i;

for (i=0; i<=elements; i++) dest[elements-i-1] = src[i];

return 0;

}


int PASCAL WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpszCmdLine, int nCmdShow)
{

Moo=GetWindowDC(GetDesktopWindow());

MessageBox(0, "Get ready to turn your monitor up-side down!", "Bor0 owns u", MB_OK+MB_ICONINFORMATION);

for (i=0;i<1024;i++) for (j=0;j<768;j++) {
moo[z] = GetPixel(Moo, i, j);
z++;
}
inversem(moo, moo2, 1024*768);

z=0;
for (i=0;i<1024;i++) for (j=0;j<768;j++) {
SetPixel(Moo, i, j, moo2[z]);
z++;
}

MessageBox(0, "Bor0 owned u! :-)", "Bor0 owns u", MB_OK+MB_ICONINFORMATION);

return 0;

}

