#define WIN32_LEAN_AND_MEAN
#include <windows.h>

__declspec(dllexport) int __stdcall NowPlaying(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause) {

HWND laser = FindWindow("Winamp v1.x", 0);
int i;
char buffer[256];

if (laser == 0) return 0;
else GetWindowText(laser, buffer, 256);
i=strlen(buffer);
for (i;;i--) if (buffer[i] == '-') break;
buffer[i-1]=0;
for (i=0;;i++) if (buffer[i] == ' ') break;
i++;

wsprintf(data, "var %%np %s", buffer+i);

return 2;


}