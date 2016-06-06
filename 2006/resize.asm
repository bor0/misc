.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
szWindow db "Untitled - Notepad", 0

.code
start:

invoke FindWindow, 0, ADDR szWindow
push eax

;-----
push 1  ; repaint
push 10 ; height
push 10 ; width
push 10 ; vertical pos
push 10 ; horizontal pos
push eax

call MoveWindow
;-----

call UpdateWindow
invoke ExitProcess, 0

end start
