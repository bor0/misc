.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib


.data?
hDC    dd ?
mpoint POINT <>

.code
DrawTriangle PROC hdc:DWORD, x1:DWORD,y1:DWORD,\
x2:DWORD,y2:DWORD, x3:DWORD,y3:DWORD

invoke MoveToEx, [hDC], x1, y1, 0 ; set the point to the top-most
invoke LineTo, [hDC], x2, y2 ; from top-most, draw to left
invoke LineTo, [hDC], x3, y3 ; from the left, draw it to the right
invoke LineTo, [hDC], x1, y1 ; from the right, draw it to the top-most     

ret
DrawTriangle ENDP

start:

invoke GetDC, 0
mov [hDC], eax

push edi
push esi

xor esi, esi
xor edi, edi

@back:
invoke GetCursorPos, ADDR mpoint

cmp [mpoint.x], esi
je @F
cmp [mpoint.y], edi
je @F

mov esi, [mpoint.x]
mov edi, [mpoint.y]

sub edi, 60

mov eax, edi
add eax, 107
push eax
mov eax, esi
add eax, 61
push eax

mov eax, edi
add eax, 107
push eax
mov eax, esi
sub eax, 62
push eax

push edi
push esi

push [hDC]
call DrawTriangle

add edi, 60

@@:
invoke Sleep, 50

jmp @back

pop esi
pop edi

invoke ExitProcess, 0
end start
