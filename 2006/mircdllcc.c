#define WIN32_LEAN_AND_MEAN
#include <windows.h>

typedef int (CALLBACK* pointfunc)(char* moo);
pointfunc CheckCredit;

__declspec(dllexport) int __stdcall CheckCreditCard(HWND mWnd, HWND aWnd, char *data, char *parms, BOOL show, BOOL nopause) {

	HINSTANCE mylib=0;
	FARPROC myfunc=0;
	int i=0;

	for (i=0;i<16;i++) data[i] -= 48;

	mylib = LoadLibrary("ccdll.dll");
	myfunc = GetProcAddress(mylib, "CheckCC");

	if (!myfunc) return 3;

	CheckCredit = (pointfunc)myfunc;
	if (!CheckCredit(data))	return 0;

	return 1;
}