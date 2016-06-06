.486
.model flat, stdcall
option casemap :none
  
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data?
buffer db 256 dup(?)
buffer2 db 256 dup(?)
mystr COPYDATASTRUCT <>

.data
class db "MsnMsgrUIManager", 0
prefix db "\0Music\01\0{0} - {1}\0%s\0WMContentID", 0
muzika db "Armin van Buuren\0This world is watching me", 0
.code

start:
invoke FindWindow, ADDR class, 0
push eax

invoke wsprintf, ADDR buffer, ADDR prefix, ADDR muzika
invoke lstrlen, ADDR buffer
xor ecx, ecx
xor edx, edx
xor edi, edi
@@:
cmp ecx, eax
je @F
mov dl, byte ptr [buffer+ecx]
mov byte ptr [buffer2+edi], dl
mov byte ptr [buffer2+edi+1], 0
add edi, 2
inc ecx
jmp @B
@@:

pop eax
mov mystr.dwData, 0547h
mov mystr.cbData, 0100h
mov mystr.lpData, offset buffer2
invoke SendMessage, eax, WM_COPYDATA, 0, ADDR mystr
invoke ExitProcess,0

end start
