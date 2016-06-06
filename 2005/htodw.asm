.486
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
mystring db "BOROCOOL", 0
prefix db "%08X", 0
buffer db 32 dup(0)


.code
htodw PROC lpString:DWORD

push esi
push edi

mov edi, lpString
xor ecx, ecx
xor eax, eax
xor esi, esi

@@:
inc ecx

cmp byte ptr [edi+ecx], 0
jne @B

@@:
shl eax, 4

movzx edx, byte ptr [edi+esi]

.if edx >= 65
.if edx >= 97
sub edx, 87
.else
sub edx, 55
.endif
jmp @go
.endif

sub edx, 48

@go:
add eax, edx

inc esi

cmp ecx, esi
jne @B

pop edi
pop esi

ret

htodw ENDP

start:

invoke htodw, ADDR mystring

invoke wsprintf, ADDR buffer, ADDR prefix, eax
invoke MessageBox, 0, ADDR buffer, ADDR mystring, MB_OK

invoke ExitProcess, 0

end start
