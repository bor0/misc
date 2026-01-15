.486
.model flat, stdcall
option casemap :none
 
include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
    
.data
AppName  db "BoR0's Warcraft Memory Protection Remover", 0

MsgSucc  db "Successfully removed protection! Have fun!", 0
MsgErr   db "There was an error removing protection,", 13, 10,
            "check if War3.exe is in the same dir!", 0

FileName db "war3.exe", 0

NewByte  db 0C2h, 1Ch, 00h

MyDll    db "advapi32.dll", 0
MyFunc   db "SetSecurityInfo", 0

classic  db "war3.exe -classic", 0

.data?
byteswritten dd ?
Startup STARTUPINFO <>
ProcessInfo PROCESS_INFORMATION <>

.code
start:
invoke GetCommandLine
push eax
invoke lstrlen, eax
mov edx, eax
pop eax

mov ecx, offset classic
dec ecx

cmp dword ptr [eax+edx-4], 'cor-'
jne @F
inc ecx
@@:

invoke CreateProcess, ADDR FileName, ecx, 0, 0, 0, 0, 0, 0, ADDR Startup, ADDR ProcessInfo

invoke Sleep, 50

invoke LoadLibrary, ADDR MyDll
invoke GetProcAddress, eax, ADDR MyFunc

invoke WriteProcessMemory, ProcessInfo.hProcess, eax, ADDR NewByte, 3, byteswritten
cmp eax, 0
je @error

invoke MessageBox, 0, ADDR MsgSucc, ADDR AppName, MB_OK+MB_ICONINFORMATION

@end:
invoke CloseHandle, ProcessInfo.hProcess
invoke CloseHandle, ProcessInfo.hThread
invoke ExitProcess, 0

@error:
invoke MessageBox, 0, ADDR MsgErr, ADDR AppName, MB_OK+MB_ICONERROR
invoke TerminateProcess, ProcessInfo.hProcess, 0
jmp @end

end start

