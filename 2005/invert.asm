.486
.model flat, stdcall
option casemap :none
 
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
tmpByte  db 0

.data?
hFile    dd ?
hSize    dd ?
bRead    dd ?

.code
start:
invoke CreateFile, ADDR bmpFile, GENERIC_READ+GENERIC_WRITE, 0, 0, \
OPEN_EXISTING, 0, 0
mov hFile, eax

invoke SetFilePointer, eax, 36h, 0, FILE_BEGIN ; bmp header until 36h
invoke GetFileSize, hFile, 0

sub eax, 3Ah ; skip last 3 bytes inverted
mov hSize, eax

xor ecx, ecx
not ecx

@@:add ecx, 1
push ecx

invoke ReadFile, hFile, ADDR tmpByte, 1, ADDR bRead, 0
not tmpByte ; invert!
invoke SetFilePointer, hFile, -1, 0, FILE_CURRENT ; readfile increases pointer by 1
invoke WriteFile, hFile, ADDR tmpByte, 1, ADDR bRead, 0

pop ecx
cmp ecx, hSize
jne @B

invoke CloseHandle, hFile
invoke ExitProcess, 0
end start
