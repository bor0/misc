#include <windows.h>

int WINAPI WinMain(HINSTANCE a, HINSTANCE b, LPSTR c, INT d) {
HWND target;
char appName[] = "GGC Shower by BoR0";
unsigned long proc_id;
HANDLE final;
char buffer[256];
int byte,i;

target = FindWindow(0, 0);

MessageBox(0, "Mac slab misir a? Pak go spusti GGC...\nAj ne pagaj u depresija sea ke sredime", appName, MB_ICONINFORMATION);

while (target != 0) {

GetWindowThreadProcessId(target, &proc_id);
final = OpenProcess(PROCESS_VM_READ, 0, proc_id);
if (!final) goto moo;
ReadProcessMemory(final, (LPVOID)0x20044, &byte, 4, 0);
ReadProcessMemory(final, (LPVOID)byte, &buffer, 255, 0);
CloseHandle(final);

for (byte=0;byte<256;byte+=2) {
if (buffer[byte] < 97) buffer[byte] += 32;
if (buffer[byte+2] == 0) break;
}

for (i=0;i<byte;i+=2)
if (buffer[i] == 'g' && buffer[i+2] == 'g' && \
buffer[i+4] == 'c' && buffer[i+6] == 'l' && \
buffer[i+8] == 'i' && buffer[i+10] == 'e' && \
buffer[i+12] == 'n' && buffer[i+14] == 't') {
GetWindowText(target, buffer, 12);
if (!lstrcmp(buffer, "GG E-Sports")) goto ok;
}

moo:
target = GetWindow(target, GW_HWNDNEXT);
}

MessageBox(0, "A da go uklucese GGC ne ke bese loso!\nVoopsto ne si go ni uklucil nub!", appName, MB_ICONERROR);
return 0;

ok:
ShowWindow(target, SW_SHOW);
MessageBox(0, "Eve ti go, najdi si go na ALT-Tab.\nSreken? :p", appName, MB_ICONINFORMATION);

return 0;

}
