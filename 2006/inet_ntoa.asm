.486
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data?


.code
inet_ntoa PROC lpAddress:DWORD
.data?
lpString db 16 dup(?)

.code
mov eax, lpAddress

bswap eax

movzx edx, al
push edx

movzx edx, ah
push edx

bswap eax

movzx edx, ah
push edx

movzx edx, al
push edx

push offset lpPrefix
push offset lpString
call wsprintf

mov eax, offset lpString

ret
lpPrefix:
db "%d.%d.%d.%d", 0
inet_ntoa ENDP

start:
invoke inet_ntoa, 'BoR0'
invoke MessageBox,0,eax,0,0
invoke ExitProcess,0
end start
