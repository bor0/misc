.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
solitaire db "Solitaire", 0

kernel32 db "kernel32.dll", 0
procaddr db "GetProcAddress", 0
llibrary db "LoadLibraryA", 0

.data?
hProcess  dd ?
hAddress  dd ?
hThread   dd ?
proc_id   dd ?
thread_id dd ?
procsize  dd ?
mylib     dd ?

.code
myThread PROC
jmp start2
loadlibrary dd 0
getprocaddr dd 0

mymsgbox db "MessageBoxA", 0
myuser32 db "user32.dll", 0

start2:
mov eax, ebx
add eax, dword ptr [loadlibrary-myThread]
mov edx, eax
mov eax, [eax] ; load library
mov edx, [edx+4] ; getprocaddr

push edx

mov ecx, ebx
add ecx, dword ptr [myuser32-myThread]

push ecx
call eax

pop edx

mov ecx, ebx
add ecx, dword ptr [mymsgbox-myThread]

push ecx
push eax
call edx

push 0
push 0
push 0
push 0
call eax

;stack balanced. sign off
ret
myThread ENDP

start:
mov eax, start
sub eax, myThread
mov procsize, eax

invoke LoadLibrary, ADDR kernel32
push eax
invoke GetProcAddress, eax, ADDR procaddr
mov getprocaddr, eax
pop eax
invoke GetProcAddress, eax, ADDR llibrary
mov loadlibrary, eax

invoke FindWindow, 0, ADDR solitaire
invoke GetWindowThreadProcessId, eax, ADDR proc_id

invoke OpenProcess, PROCESS_ALL_ACCESS, 0, proc_id
mov hProcess, eax

invoke VirtualAllocEx, eax, 0, [procsize], MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READ
mov hAddress, eax

invoke WriteProcessMemory, [hProcess], eax, ADDR myThread, [procsize], ADDR proc_id
invoke CreateRemoteThread, hProcess, 0, 0, hAddress, hAddress, 0, ADDR thread_id

invoke CloseHandle, eax
invoke CloseHandle, hProcess

invoke ExitProcess, 0
end start
