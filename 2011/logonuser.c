#include <windows.h>

#pragma comment(lib, "advapi32.lib")

#define RTN_ERROR 0
#define RTN_OK 1

int main(void) {
	HANDLE hToken;
	PROCESS_INFORMATION pi;
	STARTUPINFO si;

	// obtain an access token for the user
	if (!LogonUser("r2d2", NULL, "asdf", LOGON32_LOGON_NEW_CREDENTIAL, LOGON32_PROVIDER_DEFAULT, &hToken)) return RTN_ERROR;

	// initialize STARTUPINFO structure
	ZeroMemory(&si, sizeof(STARTUPINFO));
	si.cb = sizeof(STARTUPINFO);
	//si.lpDesktop = "Winsta0\\Default";

	// start the process
	if (!CreateProcessAsUser(hToken, NULL, "shutdown -i", NULL, NULL, FALSE, NORMAL_PRIORITY_CLASS|CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi)) return RTN_ERROR;
	WaitForSingleObject(pi.hProcess,INFINITE);

	// close the handles
	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);

	return RTN_OK;
}
