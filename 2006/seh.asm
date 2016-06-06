.486
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
sz1 db "Bor0's exception handler", 0
sz2 db "Cheers, all exceptions passed!", 0

.code
errorhandler PROC
;eip where exception happened
;increase pointer, continue with work
mov eax, [esp+4]
mov eax, [eax+12]
add eax, 2
jmp eax
errorhandler ENDP

start:
assume fs:nothing

push offset errorhandler
push 0
mov fs:[0], esp
   
int 80

invoke MessageBox, 0, ADDR sz2, ADDR sz1, MB_ICONINFORMATION
invoke ExitProcess, 0

end start