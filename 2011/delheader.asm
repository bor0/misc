.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc


includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
appname   db "WAVtoALL by bor0", 0

somerror  db "Some error occured due to CreateFile()", 0
allfine   db "Everything went fine!", 0

whenready db "Conversion from 'fileinput.wav' to 'fileoutput.wav'.", 13, 10
          db "Are you sure you want to continue converting?", 0

filename  db "fileinput.wav", 0
filename2 db "fileoutput.wav", 0

.data?
fileHandle   dd ?
fileHandle2  dd ?
byteswritten dd ?
mybuffer     db 10240 dup(?)

.code
start:
invoke MessageBox, 0, ADDR whenready, ADDR appname, MB_YESNO+MB_ICONQUESTION
cmp eax, IDYES
jne @end

invoke CreateFile, ADDR filename, GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0
cmp eax, INVALID_HANDLE_VALUE
je @error

mov fileHandle, eax

invoke CreateFile, ADDR filename2, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0
cmp eax, INVALID_HANDLE_VALUE
je @error

mov fileHandle2, eax

invoke ReadFile, [fileHandle], ADDR mybuffer, 44, ADDR byteswritten, 0

@@:
invoke ReadFile, [fileHandle], ADDR mybuffer, 10240, ADDR byteswritten, 0
invoke WriteFile, [fileHandle2], ADDR mybuffer, byteswritten, ADDR byteswritten, 0
cmp byteswritten, 0
jne @B

invoke MessageBox, 0, ADDR allfine, ADDR appname, MB_ICONINFORMATION+MB_OK

invoke CloseHandle, fileHandle
invoke CloseHandle, fileHandle2

@end:
invoke ExitProcess, 0

@error:
invoke MessageBox, 0, ADDR somerror, ADDR appname, MB_ICONERROR+MB_OK
jmp @end

end start
