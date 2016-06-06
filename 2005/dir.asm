.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data 
boro    db "dir.txt", 0

diry    db "*.*",0 
wfd     WIN32_FIND_DATA <>

.data?
handle  dd ?
fhand   dd ?
bytwrit dd ?


.code 
start:
invoke DeleteFile, ADDR boro

invoke CreateFile, ADDR boro, GENERIC_WRITE, 0, 0, CREATE_NEW, 0, 0
mov fhand, eax

invoke FindFirstFile,addr diry,addr wfd
mov handle, eax

invoke lstrlen, ADDR wfd.cFileName
mov word ptr [wfd.cFileName+eax], 0a0dh
add eax, 2

invoke WriteFile, fhand, ADDR wfd.cFileName, eax, ADDR bytwrit, 0

@@:
invoke FindNextFile, handle, ADDR wfd
cmp eax, 0
je @F

invoke lstrlen, ADDR wfd.cFileName
mov word ptr [wfd.cFileName+eax], 0a0dh
add eax, 2

invoke WriteFile, fhand, ADDR wfd.cFileName, eax, ADDR bytwrit, 0
jmp @B
@@:

invoke CloseHandle, fhand

invoke ExitProcess, 0
end start