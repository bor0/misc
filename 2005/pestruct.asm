.486                       ; create 32 bit code
.model flat, stdcall       ; 32 bit memory model
option casemap :none       ; case sensitive
 
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

PEStructure STRUCT
PEString   db "PE", 0, 0
EntryPoint dd ?
ImageBase  dd ?
PEStructure ENDS

.data
myfile     db "C:\boa\reshacker.exe", 0
prefix     db "%08X", 0

pes PEStructure <>

.data?
buffer     db 64 dup(?)

bytwrit    dd ?
fhandle    dd ?

.code
start:
invoke CreateFile, ADDR myfile, GENERIC_WRITE+GENERIC_READ, 0, 0, OPEN_ALWAYS, 0, 0
cmp eax, INVALID_HANDLE_VALUE
je @end

mov [fhandle], eax

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; look up for string "PE" here

push esi
xor esi, esi
add esi, 20h ;skip the dosheader which is 20h long

@@:
invoke ReadFile, [fhandle], ADDR pes.EntryPoint, 4, ADDR bytwrit, 0
invoke SetFilePointer, [fhandle], esi, 0, FILE_BEGIN

inc esi

invoke lstrcmp, ADDR pes.PEString, ADDR pes.EntryPoint
test eax, eax
jne @B

pop esi
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; add another 27h after we found the "PE" string
; ENTRY POINT at mybuffer

invoke SetFilePointer, [fhandle], 27h, 0, FILE_CURRENT
invoke ReadFile, [fhandle], ADDR pes.EntryPoint, 4, ADDR bytwrit, 0

; get image base
invoke SetFilePointer, [fhandle], 8, 0, FILE_CURRENT
invoke ReadFile, [fhandle], ADDR pes.ImageBase, 4, ADDR bytwrit, 0
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

mov eax, pes.EntryPoint
add eax, pes.ImageBase

invoke wsprintf, ADDR buffer, ADDR prefix, eax
invoke MessageBox, 0, ADDR buffer, 0, 0

invoke CloseHandle, [fhandle]

@end:
invoke ExitProcess, 0
end start
