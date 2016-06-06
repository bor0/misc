.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data
mystring db "Deep Freeze hax by bor0", 0

success  db "Successfully cloned Deep Freeze!", 13, 10,
            "You can now attach to the clone with a debugger ;-)", 0

error    db "Some unknown error occured.", 13, 10,
            "Make sure Window exists and so the file", 32

myfile   db "dfhack.bor0", 0

.data?
temp_id  dd ?
handle   dd ?
bytwrit  dd ?

mybuffer db 256 dup(?)
mybuff2  db 256 dup(?)
mybuff3  db 256 dup(?)

startup STARTUPINFO <>
processinfo PROCESS_INFORMATION <>

.code
start:
invoke CreateFile, ADDR myfile, GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0

mov handle, eax
invoke ReadFile, eax, ADDR mybuffer, 256, ADDR bytwrit, 0
push eax
invoke CloseHandle, handle
pop eax

test eax, eax
je @error

invoke FindWindow, 0, ADDR mybuffer

test eax, eax
je @error

invoke GetWindowThreadProcessId, eax, ADDR temp_id
invoke OpenProcess, PROCESS_VM_READ, 0, temp_id
mov handle, eax

invoke ReadProcessMemory, eax, [020000h+68], ADDR mybuffer, 256, ADDR bytwrit
mov eax, dword ptr [mybuffer]
invoke ReadProcessMemory, [handle], eax, ADDR mybuffer, 256, ADDR bytwrit

xor ecx, ecx
xor eax, eax
@@:

.IF byte ptr [mybuffer+ecx] != 0
mov dl, byte ptr [mybuffer+ecx]
mov byte ptr [mybuff2+eax], dl
inc eax
.ENDIF

cmp word ptr [mybuffer+ecx], 0
je @F

inc ecx
jmp @B
@@:

invoke ReadProcessMemory, [handle], [020000h+60], ADDR mybuffer, 256, ADDR bytwrit
mov eax, dword ptr [mybuffer]
invoke ReadProcessMemory, [handle], eax, ADDR mybuffer, 256, ADDR bytwrit

xor ecx, ecx
xor eax, eax
@@:

.IF byte ptr [mybuffer+ecx] != 0
mov dl, byte ptr [mybuffer+ecx]
mov byte ptr [mybuff3+eax], dl
inc eax
.ENDIF

cmp word ptr [mybuffer+ecx], 0
je @F

inc ecx
jmp @B
@@:

invoke CreateProcess, ADDR mybuff3, ADDR mybuff2, 0, 0, 0, 0, 0, 0, ADDR startup, ADDR processinfo

test eax, eax
je @error

invoke MessageBox, 0, ADDR success, ADDR mystring, MB_OK+MB_ICONINFORMATION

invoke CloseHandle, [processinfo.hProcess]
invoke CloseHandle, [handle]
@@:
invoke ExitProcess, 0

@error:
invoke MessageBox, 0, ADDR error, ADDR mystring, MB_OK+MB_ICONERROR
jmp @B

end start
