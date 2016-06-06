#include <stdio.h>
#include <windows.h>

/*
y = [435048], x = [43504C];
map = [434C21];
004051A6 CMP EAX,100; [esp+4] == WM_KEYDOWN
*/

int main() {
char soko[16][20];
int x,y; HWND target;
unsigned long proc_id; HANDLE souko;
int i = 0x434C20; char sokox, sokoy;

printf("Soukoban Teleporter v1.0 by BoR0\n   written 25.05.2007 in 2 hours\n\
--------------------------------\n\n");

target = FindWindow(0, "Soukoban");

if (!target) {
printf("Unable to find window: \"Soukoban\".\n");
return 0;
}

GetWindowThreadProcessId(target, &proc_id);
souko = OpenProcess(PROCESS_ALL_ACCESS, FALSE, proc_id);

if (!souko) {
printf("Unable to gain privileges for application.\n");
return 0;
}

for (y=0;y<16;y++) for (x=0;x<20;x++)
ReadProcessMemory(souko, (LPVOID)i++, &soko[y][x], 1, 0);

ReadProcessMemory(souko, (LPVOID)0x435048, &sokoy, 1, 0);
ReadProcessMemory(souko, (LPVOID)0x43504C, &sokox, 1, 0);

soko[sokoy][sokox] = 6;

printf("Current map status:\n");

for (y=0;y<16;y++) {
for (x=0;x<20;x++)
if (soko[y][x] == 0) printf(" ");
else printf("%c", soko[y][x]+64);
printf("\n");
}

printf("Scheme:\nA = Wall\nB = Path\nC = Box destination\nD = Box\nE = Box on it's place\nF = \
Current location \n\nYour current location coords: (%d, %d)\nDo you want to change coords? [y/N] \
", sokox, sokoy);

scanf("%c", &sokoy);

if (sokoy == 'y' || sokoy == 'Y') {
printf("Enter new coords: \n");
scanf("%d%d", &x, &y);

if ((x > 19) || (x < 0) || (y > 15) || (y < 0)) {
printf("Invalid coordinates!\n");
goto done;
}

if (WriteProcessMemory(souko, (LPVOID)0x435048, &y, 1, 0) == 0 || \
WriteProcessMemory(souko, (LPVOID)0x43504C, &x, 1, 0) == 0)
printf("Error in writing to memory!");
else {
printf("Successfully written new coords (%d, %d)\n", x, y);
InvalidateRect(target, 0, 0);
}

}

done:
printf("All done.\n");

CloseHandle(souko);

return 0;

}
