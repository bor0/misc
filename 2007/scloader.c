#include <windows.h>

/* Procedure of constant update
004885B0   $ 0FB6C9          MOVZX ECX,CL
004885B3   . 83E9 00         SUB ECX,0                                ;  Switch (cases 0..2)
004885B6   . 74 31           JE SHORT starcraf.004885E9
004885B8   . 49              DEC ECX
004885B9   . 74 1A           JE SHORT starcraf.004885D5
004885BB   . 49              DEC ECX
004885BC   . 74 03           JE SHORT starcraf.004885C1
004885BE   . 33C0            XOR EAX,EAX                              ;  Default case of switch 004885B3
004885C0   . C3              RETN
004885C1   > 0FB6C0          MOVZX EAX,AL                             ;  Case 2 of switch 004885B3
004885C4   . C1E0 02         SHL EAX,2
004885C7   . 8B88 4C225800   MOV ECX,DWORD PTR DS:[EAX+58224C]
004885CD   . E9 D3550700     JMP starcraf.004FDBA5
004885D2     00              DB 00
004885D3   . EB 26           JMP SHORT starcraf.004885FB
004885D5   > 0FB6C0          MOVZX EAX,AL                             ;  Case 1 of switch 004885B3
004885D8   . C1E0 02         SHL EAX,2
004885DB   . 8B88 BC215800   MOV ECX,DWORD PTR DS:[EAX+5821BC]
004885E1   . E9 D4550700     JMP starcraf.004FDBBA
004885E6     00              DB 00
004885E7   . EB 12           JMP SHORT starcraf.004885FB
004885E9   > 0FB6C0          MOVZX EAX,AL                             ;  Case 0 of switch 004885B3
004885EC   . C1E0 02         SHL EAX,2
004885EF   . 8B88 2C215800   MOV ECX,DWORD PTR DS:[EAX+58212C]
004885F5   . E9 D5550700     JMP starcraf.004FDBCF
004885FA     00              DB 00
004885FB   > 3BC8            CMP ECX,EAX
004885FD   . 73 02           JNB SHORT starcraf.00488601
004885FF   . 8BC1            MOV EAX,ECX
00488601   > C3              RETN
*/

#define starcraft ProcessInfo.hProcess

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {
const char appName[] = "BoR0's Starcraft 1.15 Limit Trainer";

unsigned char datatrain1[] = { 0xE9, 0xD3, 0x55, 0x07, 0x00 };
unsigned char datatrain2[] = { 0xC7, 0x80, 0xAC, 0x22, 0x58,\
0x00, 0xAD, 0xDE, 0x00, 0x00, 0x8B, 0x80, 0xAC, 0x22, 0x58,\
0x00, 0xE9, 0x19, 0xAA, 0xF8, 0xFF };

unsigned char datatrain3[] = { 0xE9, 0xD4, 0x55, 0x07, 0x00 };
unsigned char datatrain4[] = { 0xC7, 0x80, 0x1C, 0x22, 0x58,\
0x00, 0xAD, 0xDE, 0x00, 0x00, 0x8B, 0x80, 0x1C, 0x22, 0x58,\
0x00, 0xE9, 0x18, 0xAA, 0xF8, 0xFF };

unsigned char datatrain5[] = { 0xE9, 0xD5, 0x55, 0x07, 0x00 };
unsigned char datatrain6[] = { 0xC7, 0x80, 0x8C, 0x21, 0x58,\
0x00, 0xAD, 0xDE, 0x00, 0x00, 0x8B, 0x80, 0x8C, 0x21, 0x58,\
0x00, 0xE9, 0x17, 0xAA, 0xF8, 0xFF };

unsigned char securityinfo[] = { 0xEB, 0x0B, 0x66, 0x69, 0x78,\
0x20, 0x62, 0x79, 0x20, 0x62, 0x6F, 0x72, 0x30 };

unsigned char checkversion[] = { 0x51, 0x53, 0x53, 0x68, 0x04,\
0x00, 0x00, 0x80, 0x6A, 0x06, 0x52, 0xFF, 0xD0 };

unsigned char temp[13];

STARTUPINFO Startup = { sizeof(Startup) };
PROCESS_INFORMATION ProcessInfo;
int i;

if (!CreateProcess("starcraft.exe", 0, 0, 0, 0, CREATE_SUSPENDED, 0, 0, &Startup, &ProcessInfo)) {
MessageBox(0, "CreateProcess(); failed!", appName, MB_OK+MB_ICONERROR);
return 0;
}

ReadProcessMemory(starcraft, (LPVOID)0x004DFEFF, &temp, 13, 0);

for (i=0;i<13;i++) if (temp[i] != checkversion[i]) {
MessageBox(0, "Wrong version! I want 1.15", appName, MB_OK+MB_ICONERROR);
TerminateProcess(starcraft, 0);
return 0;
}

WriteProcessMemory(starcraft, (LPVOID)0x004DFEFF, &securityinfo, 13, 0);

if (MessageBox(0, "Successfully removed memory protection.\nWould you \
like to enable limit trainer?", appName, MB_YESNO+MB_ICONASTERISK) == IDYES) {

/* Protoss:
004885CD   E9 D3550700                   JMP StarCraf.004FDBA5
004FDBA5   C780 AC225800 ADDE0000        MOV DWORD PTR DS:[EAX+5822AC],0DEAD
004FDBAF   8B80 AC225800                 MOV EAX,DWORD PTR DS:[EAX+5822AC]
004FDBB5  ^E9 19AAF8FF                   JMP StarCraf.004885D3
*/
WriteProcessMemory(starcraft, (LPVOID)0x004885CD, &datatrain1, 5, 0);
WriteProcessMemory(starcraft, (LPVOID)0x004FDBA5, &datatrain2, 21, 0);

/* Terran:
004885E1   E9 D4550700                   JMP StarCraf.004FDBBA
004FDBBA   C780 1C225800 ADDE0000        MOV DWORD PTR DS:[EAX+58221C],0DEAD
004FDBC4   8B80 1C225800                 MOV EAX,DWORD PTR DS:[EAX+58221C]
004FDBCA  ^E9 18AAF8FF                   JMP StarCraf.004885E7
*/
WriteProcessMemory(starcraft, (LPVOID)0x004885E1, &datatrain3, 5, 0);
WriteProcessMemory(starcraft, (LPVOID)0x004FDBBA, &datatrain4, 21, 0);

/* Zerg:
004885F5   E9 D5550700                   JMP StarCraf.004FDBCF
004FDBCF   C780 8C215800 ADDE0000        MOV DWORD PTR DS:[EAX+58218C],0DEAD
004FDBD9   8B80 8C215800                 MOV EAX,DWORD PTR DS:[EAX+58218C]
004FDBDF  ^E9 17AAF8FF                   JMP StarCraf.004885FB
*/
WriteProcessMemory(starcraft, (LPVOID)0x004885F5, &datatrain5, 5, 0);
WriteProcessMemory(starcraft, (LPVOID)0x004FDBCF, &datatrain6, 21, 0);

WriteProcessMemory(starcraft, (LPVOID)0x004C4C85, &securityinfo, 1, 0); //multiplayer

MessageBox(0, "Successfully trained!", appName, MB_OK+MB_ICONINFORMATION);

}

ResumeThread(ProcessInfo.hThread);

CloseHandle(starcraft);
CloseHandle(ProcessInfo.hThread);

return 0;

}