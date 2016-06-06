#include <windows.h>

#define WH_KEYBOARD_LL 13

typedef struct {
DWORD vkCode;
DWORD scanCode;
DWORD flags;
DWORD time;
ULONG_PTR dwExtraInfo;
} KBDLLHOOKSTRUCT, *PKBDLLHOOKSTRUCT;

MSG msg;
HHOOK keyhook;

DWORD CALLBACK Hook1(int nCode, WPARAM wParam, LPARAM lParam) {

KBDLLHOOKSTRUCT *pkbhs = (KBDLLHOOKSTRUCT *)lParam;
return CallNextHookEx(keyhook, nCode, wParam, lParam);
}


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {

keyhook = SetWindowsHookExA(WH_KEYBOARD_LL, (HOOKPROC)Hook1, GetModuleHandle(0), 0);

if (!keyhook) return 0;

GetMessage(&msg, 0, 0, 0);
UnhookWindowsHookEx(keyhook);

return 0;
}
