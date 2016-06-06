.486
.model flat, stdcall
option casemap :none
 
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data

mydata db "L to the o to the l =)", 0
separator db ' ', 0

mydata2 db "L.to.the.o.to.the.l.=)", 0
separator2 db '.', 0


.code
SeparateWords PROC uses esi edi lpString:DWORD, lpSeparator:DWORD, callback:DWORD

invoke lstrlen, lpString

mov edx, lpSeparator
mov dl, byte ptr [edx]
mov esi, lpString
xor edi, edi
xor ecx, ecx
dec ecx

@here: inc ecx

cmp byte ptr [esi+ecx], dl
jne @F

mov byte ptr [esi+ecx], 0

pushad
mov edx, callback
call edx
popad

mov edi, ecx
inc edi

@@: cmp ecx, eax
jne @here

mov edx, callback
call edx

ret

SeparateWords ENDP

CallBack PROC
invoke MessageBox, 0, ADDR [esi+edi], 0, 0
ret
CallBack ENDP

start:

invoke SeparateWords, ADDR mydata, ADDR separator, ADDR CallBack
invoke SeparateWords, ADDR mydata2, ADDR separator2, ADDR CallBack

invoke ExitProcess, 0

end start
