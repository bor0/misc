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

;1024x768

res1 EQU 1024
res2 EQU 768


.data
warwin  db "Coordinate system painter by BoR0", 0
press   db "Press OK when you want to stop the painting.", 0

.data?
hDC     dd ?
hThread dd ?

.code
MyThread PROC

fromhere:

push edi
xor edi, edi

@@:
add edi, 8

invoke MoveToEx, [hDC], 0, edi, 0
invoke LineTo, [hDC], res1, edi

invoke MoveToEx, [hDC], edi, 0, 0
invoke LineTo, [hDC], edi, res2

cmp edi, res1
jnge @B

pop edi

invoke Sleep, 40
jmp fromhere

ret

MyThread ENDP

start:
invoke GetWindowDC, 0
mov [hDC], eax

invoke CreateThread, 0, 0, ADDR MyThread, 0, 0, ADDR hThread
mov [hThread], eax

invoke MessageBox, 0, ADDR press, ADDR warwin, MB_OK+MB_ICONINFORMATION
invoke TerminateThread, [hThread], 0
invoke InvalidateRect, 0, 0, 0

invoke ExitProcess, 0
end start
