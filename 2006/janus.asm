.486
.model flat, stdcall
option casemap :none
  
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data
janus db "C:\Windows", 0
more  db "J3fd.his", 0

app db "Janus 3.0 crack by BoR0", 0
suc db "Datata e uspesno resetirana!", 0
err db "Imase greska pri resetiranje (mozebi veke e resetirana?).", 0

.code
start:
invoke CreateDirectory, ADDR janus, 0  
cmp eax, 1
je @suc

mov byte ptr [janus+10], '\'
invoke DeleteFile, ADDR janus
test eax, eax

je @fail

@suc:
invoke MessageBox, 0, ADDR suc, ADDR app, MB_ICONINFORMATION+MB_OK

@end:
invoke ExitProcess, 0

@fail:
invoke MessageBox, 0, ADDR err, ADDR app, MB_ICONERROR+MB_OK
jmp @end
end start
