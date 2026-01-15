.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data
warwin  db "Warcraft III alt locker by BoR0", 0
war3    db "Warcraft III", 0
press   db "Press OK when you want to stop the alt-lock.", 0

.data?
hThread dd ?

.code
MyThread PROC

@@:
invoke FindWindow, ADDR war3, ADDR war3
push eax
invoke SendMessage, eax, WM_KEYDOWN, 0DDh, 0
pop eax
invoke SendMessage, eax, WM_KEYDOWN, 0DBh, 0

invoke Sleep, 500
jmp @B

MyThread ENDP

start:
invoke CreateThread, 0, 0, ADDR MyThread, 0, 0, ADDR hThread
mov [hThread], eax

invoke MessageBox, 0, ADDR press, ADDR warwin, MB_OK+MB_ICONINFORMATION

invoke TerminateThread, [hThread], 0

invoke ExitProcess, 0

end start
