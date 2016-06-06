#include <stdio.h>
#include <windows.h>

#define MAXFILES 255
#define MAXFILENAMESIZE 255


int WINAPI WinMain() {

char files[MAXFILES][MAXFILENAMESIZE];
char addition[] = "scorpik - ";
char skipfile[] = "findfiles.exe";
char wildcard[] = "*.*";
char buffer[MAXFILENAMESIZE];
WIN32_FIND_DATA fdata;
HANDLE hfile;
int i = 0;


hfile = FindFirstFile(wildcard, &fdata);
FindNextFile(hfile, &fdata);

while (FindNextFile(hfile, &fdata) != 0) {
strcpy(files[i], fdata.cFileName);
i++;
}

for (i-=1;i>=0;i--) {

if (strcmp(files[i], skipfile) == 0) continue;

strcpy(buffer, addition);
strcat(buffer, files[i]);

MoveFile(files[i], buffer);

}

return 0;

}