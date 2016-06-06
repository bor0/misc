;looks retarded, i know
;still messy though, lots of
;bugs i know and lots of optimizations
;are yet to come

.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

NUMBER equ 798

.data
buffer db 32 dup(0)
prefix db "%d", 0

.code
revert PROC number:DWORD
;reverts a 3-numbered number
;e.x.: 123 -> 321

xor edx, edx
mov eax, number
mov ecx, 100
div ecx

mov cl, al

mov eax, edx
mov ch, 10
div ch

mov ch, al
shl ecx, 8

mov cl, ah

xor eax, eax
mov al, cl
mov edx, 100
mul edx

mov [esp], eax
xor eax, eax

shr ecx, 8
mov al, ch
mov edx, 10
mul edx

add eax, [esp]

add al, cl
ret

revert ENDP

start:
invoke wsprintf, ADDR buffer, ADDR prefix, NUMBER
invoke MessageBox,0,ADDR buffer,0,0

invoke revert, NUMBER

invoke wsprintf, ADDR buffer, ADDR prefix, eax
invoke MessageBox,0,ADDR buffer,0,0

invoke ExitProcess, 0
end start
