.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\advapi32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\advapi32.lib

.data
window   db "Garena", 0
appname  db "GGC Protection version 2.4.0.1134 Remover by BoR0", 0
succtr   db "Successfully removed protection.", 0
errtr    db "Error occured while removing protection.", 0

hack1 db 0B0h, 01h

.data?
handle   dd ?
bytwrit  dd ?
proc_id  dd ?
hToken   dd ?
tp       TOKEN_PRIVILEGES <>
luid     dd ?

.code
start:
invoke FindWindow, 0, ADDR window
test eax, eax
je @error

invoke GetWindowThreadProcessId, eax, ADDR proc_id
invoke OpenProcess, PROCESS_ALL_ACCESS, 0, proc_id
mov handle, eax

invoke WriteProcessMemory, handle, 004EDFC8h, ADDR hack1, 2, 0
test eax, eax
je @error

invoke MessageBox, 0, ADDR succtr, ADDR appname, MB_OK+MB_ICONINFORMATION

@end:
invoke CloseHandle, [handle]
invoke ExitProcess, 0

@error:
invoke MessageBox, 0, ADDR errtr, ADDR appname, MB_OK+MB_ICONERROR
jmp @end

end start
