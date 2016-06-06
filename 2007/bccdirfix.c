#include <windows.h>

//08.june.2007 by bor0

int WINAPI WinMain(HINSTANCE a, HINSTANCE b, LPSTR c, INT d) {
char buffer[256]; char buffer2[256];
HANDLE file;
int i,t; DWORD bytwrit;

MessageBox(0, "This program will automaticly make ilink32.cfg and bcc32.cfg\nFiles that are needed in order to be able to compile your\nprograms using BC++ compiler.\n\nOnce you press OK I will create 2 files in the folder you run me from.\n(make sure it's in the Bin/ folder)", "Bccdirfix by BoR0", MB_OK+MB_ICONINFORMATION);

GetCurrentDirectory(sizeof buffer, buffer);

i = strlen(buffer);

for (i;;i--) if (buffer[i] == '\\' || buffer[i] == '/') break;
buffer[i+1] = 0;

wsprintf(buffer2, "-I\"%s\include\"\x0D\x0A-L\"%s\lib\"", buffer, buffer);

file = CreateFile("bcc32.cfg", GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0);
t = strlen(buffer2);
WriteFile(file, buffer2, t, &bytwrit, 0);
CloseHandle(file);

file = CreateFile("ilink32.cfg", GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0);
i+=14; t = strlen(buffer2+i);
WriteFile(file, buffer2+i, t, &bytwrit, 0);
CloseHandle(file);

return 0;
}