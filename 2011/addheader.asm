.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc


includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
appname   db "ALLtoWAV by bor0", 0

somerror  db "Some error occured due to CreateFile()", 0
allfine   db "Everything went fine!", 0

whenready db "Conversion from 'fileinput.wav' to 'fileoutput.wav'.", 13, 10
          db "Are you sure you want to continue converting?", 0

filename  db "fileinput.wav", 0
filename2 db "fileoutput.wav", 0

wavheader db 052h, 049h, 046h, 046h, 0F8h, 0FFh, 0FFh, 0FFh, 057h, 041h
          db 056h, 045h, 066h, 06Dh, 074h, 020h, 010h, 000h, 000h, 000h
          db 001h, 000h, 002h, 000h, 044h, 0ACh, 000h, 000h, 010h, 0B1h
          db 002h, 000h, 004h, 000h, 010h, 000h, 064h, 061h, 074h, 061h
          db 0D4h, 0FFh, 0FFh, 0FFh

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

invoke WriteFile, [fileHandle2], ADDR wavheader, 44, ADDR byteswritten, 0

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
