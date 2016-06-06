#include <windows.h>
#include <stdio.h>

using namespace std;

typedef int  (*MsgBox)( HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);

int _tmain(int argc, _TCHAR* argv[]) {

	HMODULE dll = LoadLibraryA("user32.dll");
	MsgBox messagebox = (MsgBox)GetProcAddress(dll, "MessageBoxA");

	messagebox(0,(LPCTSTR)"Hello World",0,0);

	FreeLibrary(dll);
	printf("DONE!\n");

	return 0;
}