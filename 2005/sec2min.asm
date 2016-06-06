.486                      ; create 32 bit code
.model flat, stdcall      ; 32 bit memory model
option casemap :none      ; case sensitive

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
slength  dd 139           ; length (in seconds)
buffer   db "%d:%d", 32 dup(0)

.code
start:
xor eax, eax

@@:
cmp slength, 60
jl @F

add eax, 1
sub slength, 60

jmp @B
@@:

invoke wsprintf, ADDR buffer, ADDR buffer, eax, slength
invoke MessageBox, 0, ADDR buffer, 0, 0
invoke ExitProcess, 0

end start
