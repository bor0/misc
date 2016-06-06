.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include \masm32\include\advapi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\shell32.inc

includelib \masm32\lib\advapi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\shell32.lib

.data
subdir db "SOFTWARE\PopCap\TyperShark", 0
submoo db "RegName" ,0

moomsg db "Cracked by "
myuser db "BoR0", 0
mykey  db "2FGM6-VTPMY-XHM44-36W3F", 0

myprg  db "WinTS.com", 0
dowhat db "open", 0

hKey   dd ?

.code
start:
invoke RegCreateKey, HKEY_LOCAL_MACHINE, addr subdir, KEY_WRITE
invoke RegOpenKey, HKEY_LOCAL_MACHINE, addr subdir, ADDR hKey

invoke RegSetValueEx, hKey, addr submoo, 0, REG_SZ, addr myuser, sizeof myuser

mov dword ptr [submoo+3], 'edoC'
invoke RegSetValueEx, hKey, addr submoo, 0, REG_SZ, addr mykey, sizeof mykey

invoke MessageBox, 0, ADDR subdir, ADDR moomsg, MB_ICONINFORMATION+MB_OK

invoke ShellExecute, 0, ADDR dowhat, ADDR myprg, 0, 0, SW_SHOWNORMAL

invoke ExitProcess, 0

end start
