.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\advapi32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\advapi32.lib

.data
window   db "Warcraft III", 0, "War3x MapHack by BoR0", 0
succtr   db "Successfully trained.", 0
errtr    db "Error occured while training.", 0
debugnam db "SeDebugPrivilege", 0

hack1 db 066h, 08Bh, 050h, 03Ch
hack2 db 074h
hack3 db 08Bh, 009h, 090h
hack4 EQU OFFSET hack3
hack5 db 040h, 033h, 0C0h, 042h, 033h, 0D2h
hack6 db 047h, 033h, 0FFh
hack7 EQU OFFSET hack22+3
hack8 db 042h, 033h, 0D2h
hack9 db 040h, 033h, 0C0h
hack10 EQU OFFSET hack22
hack11 EQU OFFSET hack8
hack12 db 039h
hack13 EQU OFFSET hack37+5
hack14 EQU OFFSET hack12
hack15 db 075h
hack16 EQU OFFSET hack12
hack17 EQU OFFSET hack37+5
hack18 db 040h, 0C3h
hack19 db 090h, 090h, 090h, 090h, 0B8h, 001h, 00h, 00h, 00h
hack20 EQU OFFSET hack8
hack21 EQU OFFSET hack8
hack22 db 043h, 033h, 0DBh, 041h, 033h, 0C9h
hack23 EQU OFFSET hack8
hack24 EQU OFFSET hack22+3
hack25 EQU OFFSET hack19
hack26 EQU OFFSET hack19
hack27 db 090h, 090h, 090h, 090h, 090h, 090h
hack28 EQU OFFSET hack27
hack29 EQU OFFSET hack19
hack30 EQU OFFSET hack19
hack31 EQU OFFSET hack27
hack32 EQU OFFSET hack19
hack33 EQU OFFSET hack19
hack34 EQU OFFSET hack27
hack35 EQU OFFSET hack27
hack36 EQU OFFSET hack27
hack37 db 0E8h, 067h, 0B0h, 016h, 000h, 085h, 0C0h
hack38 EQU OFFSET hack37+5
hack39 db 0EBh, 0CEh, 090h, 090h, 090h, 090h
hack40 EQU OFFSET hack37+4
hack41 EQU OFFSET hack39
hack42 EQU OFFSET hack39
hack43 EQU OFFSET hack39
hack44 EQU OFFSET hack39
hack45 db 003h
hack46 EQU OFFSET hack45
hack47 db 0EBh, 002h
hack48 db 0EBh, 006h
hack49 EQU OFFSET hack19
hack50 EQU OFFSET hack19
hack51 EQU OFFSET hack19
hack52 EQU OFFSET hack39
hack53 EQU OFFSET hack27
hack54 EQU OFFSET hack9
hack55 EQU OFFSET hack22+3
hack56 EQU OFFSET hack22+3
hack57 EQU OFFSET hack22+3
hack58 db 0BAh, 0FFh, 0FFh, 0FFh, 0FFh, 090h
hack59 db 0B8h, 0D2h, 0FFh, 000h, 0FFh, 090h
hack60 db 0B9h, 000h, 000h, 0FFh, 0FFh, 090h
hack61 db 0BAh, 000h, 0AAh, 0AAh, 0FFh, 090h

.data?
handle   dd ?
bytwrit  dd ?
proc_id  dd ?
hToken   dd ?
tp       TOKEN_PRIVILEGES <>
luid     dd ?

.code
start:
invoke ImpersonateSelf, 2 ;securityimpersonation
invoke GetCurrentThread
invoke OpenThreadToken, eax, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, 0, ADDR hToken

invoke LookupPrivilegeValue, 0, ADDR debugnam, ADDR tp.Privileges[0].Luid
mov tp.PrivilegeCount, 1
mov tp.Privileges[0].Attributes, SE_PRIVILEGE_ENABLED
invoke AdjustTokenPrivileges, [hToken], 0, ADDR tp, SIZEOF TOKEN_PRIVILEGES, 0, 0

invoke FindWindow, 0, ADDR window
test eax, eax
je @error

invoke GetWindowThreadProcessId, eax, ADDR proc_id
invoke OpenProcess, PROCESS_ALL_ACCESS, 0, proc_id
mov handle, eax

invoke WriteProcessMemory, handle, 6F40A927h, ADDR hack1, 4, 0
test eax, eax
je @error

invoke WriteProcessMemory, handle, 6F40AA60h, ADDR hack2, 1, 0
invoke WriteProcessMemory, handle, 6F40AA7Eh, ADDR hack3, 3, 0
invoke WriteProcessMemory, handle, 6F40AA83h, hack4, 3, 0
invoke WriteProcessMemory, handle, 6F2A3C03h, ADDR hack5, 6, 0
invoke WriteProcessMemory, handle, 6F074325h, ADDR hack6, 3, 0
invoke WriteProcessMemory, handle, 6F07432Bh, hack7, 3, 0
invoke WriteProcessMemory, handle, 6F0735D5h, ADDR hack8, 3, 0
invoke WriteProcessMemory, handle, 6F0735E1h, ADDR hack9, 3, 0
invoke WriteProcessMemory, handle, 6F17EA6Ch, hack10, 3, 0
invoke WriteProcessMemory, handle, 6F17EA72h, hack11, 3, 0
invoke WriteProcessMemory, handle, 6F325E34h, ADDR hack12, 1, 0
invoke WriteProcessMemory, handle, 6F325E37h, hack13, 1, 0
invoke WriteProcessMemory, handle, 6F325E47h, hack14, 1, 0
invoke WriteProcessMemory, handle, 6F325E49h, ADDR hack15, 1, 0
invoke WriteProcessMemory, handle, 6F149540h, hack16, 1, 0
invoke WriteProcessMemory, handle, 6F149543h, hack17, 1, 0
invoke WriteProcessMemory, handle, 6F1B01BCh, ADDR hack18, 2, 0
invoke WriteProcessMemory, handle, 6F17D878h, ADDR hack19, 9, 0
invoke WriteProcessMemory, handle, 6F30CFA3h, hack20, 3, 0
invoke WriteProcessMemory, handle, 6F30CFAAh, hack21, 3, 0
invoke WriteProcessMemory, handle, 6F2A3AA5h, ADDR hack22, 6, 0
invoke WriteProcessMemory, handle, 6F2A31DCh, hack23, 3, 0
invoke WriteProcessMemory, handle, 6F2A31F4h, hack24, 3, 0
invoke WriteProcessMemory, handle, 6F12DC3Ah, hack25, 2, 0
invoke WriteProcessMemory, handle, 6F12DC7Ah, hack26, 2, 0
invoke WriteProcessMemory, handle, 6F55B48Eh, ADDR hack27, 6, 0
invoke WriteProcessMemory, handle, 6F55014Fh, hack28, 6, 0
invoke WriteProcessMemory, handle, 6F5621ECh, hack29, 2, 0
invoke WriteProcessMemory, handle, 6F4A50D0h, hack30, 2, 0
invoke WriteProcessMemory, handle, 6F4626CEh, hack31, 6, 0
invoke WriteProcessMemory, handle, 6F46A457h, hack32, 2, 0
invoke WriteProcessMemory, handle, 6F4472A5h, hack33, 2, 0
invoke WriteProcessMemory, handle, 6F46F188h, hack34, 6, 0
invoke WriteProcessMemory, handle, 6F45E571h, hack35, 6, 0
invoke WriteProcessMemory, handle, 6F446BF0h, hack36, 6, 0
invoke WriteProcessMemory, handle, 6F137C04h, ADDR hack37, 7, 0
invoke WriteProcessMemory, handle, 6F137C0Ch, hack38, 1, 0
invoke WriteProcessMemory, handle, 6F137C11h, ADDR hack39, 6, 0
invoke WriteProcessMemory, handle, 6F149208h, hack40, 1, 0
invoke WriteProcessMemory, handle, 6F1C2C7Eh, hack41, 1, 0
invoke WriteProcessMemory, handle, 6F13EF63h, hack42, 1, 0
invoke WriteProcessMemory, handle, 6F2406ACh, hack43, 1, 0
invoke WriteProcessMemory, handle, 6F2407BFh, hack44, 1, 0
invoke WriteProcessMemory, handle, 6F221C94h, ADDR hack45, 1, 0
invoke WriteProcessMemory, handle, 6F221CA8h, hack46, 1, 0
invoke WriteProcessMemory, handle, 6F563D17h, ADDR hack47, 2, 0
invoke WriteProcessMemory, handle, 6F15C524h, ADDR hack48, 2, 0
invoke WriteProcessMemory, handle, 6F45097Ch, hack49, 2, 0
invoke WriteProcessMemory, handle, 6F5F224Bh, hack50, 2, 0
invoke WriteProcessMemory, handle, 6F4AB8C9h, hack51, 2, 0
invoke WriteProcessMemory, handle, 6F185D86h, hack52, 1, 0
invoke WriteProcessMemory, handle, 6F462F9Ch, hack53, 6, 0
invoke WriteProcessMemory, handle, 6F147C72h, hack54, 3, 0
invoke WriteProcessMemory, handle, 6F147C77h, hack55, 3, 0
invoke WriteProcessMemory, handle, 6F148754h, hack56, 3, 0
invoke WriteProcessMemory, handle, 6F14875Bh, hack57, 3, 0
invoke WriteProcessMemory, handle, 6F149255h, ADDR hack58, 6, 0
invoke WriteProcessMemory, handle, 6F14925Eh, ADDR hack59, 6, 0
invoke WriteProcessMemory, handle, 6F149267h, ADDR hack60, 6, 0
invoke WriteProcessMemory, handle, 6F149270h, ADDR hack61, 6, 0

test eax, eax
je @error

invoke MessageBox, 0, ADDR succtr, ADDR window+13, MB_OK+MB_ICONINFORMATION

@end:
invoke LookupPrivilegeValue, 0, ADDR debugnam, ADDR tp.Privileges[0].Luid
mov tp.PrivilegeCount, 0
mov tp.Privileges[0].Attributes, SE_PRIVILEGE_ENABLED
invoke AdjustTokenPrivileges, [hToken], 0, ADDR tp, SIZEOF TOKEN_PRIVILEGES, 0, 0

invoke CloseHandle, [handle]
invoke CloseHandle, [hToken]
invoke ExitProcess, 0

@error:
invoke MessageBox, 0, ADDR errtr, ADDR window+13, MB_OK+MB_ICONERROR
jmp @end

end start
