.486
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

DeleteCharacter EQU 007E7B1Ch

.data
myApp    db "WoWNoW by Bor0", 0
success  db "Successfully disabled 'delete character' feature!", 0
error    db "There was an error while disabling 'delete character' feature!", 0

FileByte db "BoR0/WoW.exe", 0

.data?
byteswritten dd ?
Startup STARTUPINFO <>
ProcessInfo PROCESS_INFORMATION <>

.code
start:
invoke CreateProcess, ADDR FileByte, ecx, 0, 0, 0, CREATE_SUSPENDED, 0, 0, ADDR Startup, ADDR ProcessInfo

invoke WriteProcessMemory, ProcessInfo.hProcess, DeleteCharacter, ADDR FileByte, 4, ADDR byteswritten

.IF eax == 0
invoke MessageBox, 0, ADDR error, ADDR myApp, MB_OK+MB_ICONERROR
.ELSE
invoke MessageBox, 0, ADDR success, ADDR myApp, MB_OK+MB_ICONINFORMATION
.ENDIF

invoke ResumeThread, ProcessInfo.hThread
invoke CloseHandle, ProcessInfo.hProcess
invoke CloseHandle, ProcessInfo.hThread

invoke ExitProcess, 0

end start
