.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.code
start:
invoke VirtualAlloc, 0B20000h, 1D000h, MEM_RESERVE, PAGE_EXECUTE_READWRITE
invoke VirtualAlloc, 0B20000h, 1D000h, MEM_COMMIT, PAGE_EXECUTE_READWRITE

mov word ptr [eax], 0C390h
call eax

invoke VirtualFree, 0B20000h, 0, MEM_RELEASE
invoke ExitProcess, 0
end start
