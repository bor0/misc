.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data
buffer db 32 dup(0)
prefix db "%d", 13, 10, "%d", 0

.code
start:
mov eax, 123456
mov ebx, 654321

sub esp, 4
mov [esp], eax  ; push eax

sub esp, 4
mov [esp], ebx  ; push ebx

mov eax, 654321
mov ebx, 123456

invoke wsprintf, ADDR buffer, ADDR prefix, eax, ebx
invoke MessageBox, 0, ADDR buffer, 0,0

mov ebx, [esp]  ; pop ebx
add esp, 4

mov eax, [esp]  ; pop eax
add esp, 4

invoke wsprintf, ADDR buffer, ADDR prefix, eax, ebx

invoke MessageBox, 0, ADDR buffer, 0,0
ret
end start
