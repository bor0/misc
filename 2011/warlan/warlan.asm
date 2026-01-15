.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

crlf   equ 13, 10

.data
warcraft db "Warcraft III", 0, "LAN patcher by BoR0", 0

status   db "Warlan -ENABLED-", 32, crlf, crlf, "Make sure you refresh the game list.", crlf, crlf,
            "**NOTE**", crlf, "If you want to get on battle.net", crlf, "make sure you disable Warlan first!", 0

errormsg db "There was an error due to writing to memory!", 0

MyProc   db 0C7h, 46h, 1Ch, 192,168,1,20, 8Bh, 56h, 1Ch, 66h, 89h, 45h, 0EEh, 0E9h, 29h, 0DEh, 0FAh, 0FFh
toWrite  db 0E9h, 0C6h, 21h, 05h, 00

orig     db 8Bh, 56h, 1Ch, 66h, 89h, 45h, 0EEh

.data?
proc_id  dd ?
bytwrit  dd ?
handle   dd ?

.code
start:
invoke FindWindow, 0, ADDR warcraft
invoke GetWindowThreadProcessId, eax, ADDR proc_id
invoke OpenProcess, PROCESS_ALL_ACCESS, 0, proc_id
mov handle, eax

invoke ReadProcessMemory, handle, 0417376h, ADDR warcraft+12, 1, ADDR bytwrit

cmp byte ptr [warcraft+12], 08Bh
mov byte ptr [warcraft+12], 32
je @activate

invoke WriteProcessMemory, handle, 0417376h, ADDR orig, SIZEOF orig, ADDR bytwrit

.IF eax != 0
mov dword ptr [status+8], 'ASID'
mov dword ptr [status+12], 'DELB'
mov byte ptr [status+16], '-'

invoke MessageBox, 0, ADDR status, ADDR warcraft, MB_OK+MB_ICONINFORMATION
.ELSE
invoke MessageBox, 0, ADDR errormsg, ADDR warcraft, MB_OK+MB_ICONERROR
.ENDIF

@end:
invoke CloseHandle, handle
invoke ExitProcess, 0

@activate:
invoke WriteProcessMemory, handle, 0469541h, ADDR MyProc, SIZEOF MyProc, ADDR bytwrit
invoke WriteProcessMemory, handle, 0417376h, ADDR toWrite, SIZEOF toWrite, ADDR bytwrit

.IF eax != 0
invoke MessageBox, 0, ADDR status, ADDR warcraft, MB_OK+MB_ICONINFORMATION
.ELSE
invoke MessageBox, 0, ADDR errormsg, ADDR warcraft, MB_OK+MB_ICONERROR
.ENDIF

jmp @end
end start
