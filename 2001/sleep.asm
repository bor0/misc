.386
.model flat, stdcall
option casemap :none

include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

.code
start:
push esi
call GetTickCount
mov esi, eax

push edi
call GetCommandLine

mov edi, eax

push edi
call lstrlen
add eax, edi

@@:
dec eax

cmp byte ptr [eax], 0
je @end

cmp byte ptr [eax], 32
jne @B

inc eax
push esi

mov ecx, eax
xor eax, eax
xor esi, esi

@@:
shl eax, 4

movzx edx, byte ptr [ecx+esi]

.if edx >= 65
.if edx >= 97
sub edx, 87
.else
sub edx, 55
.endif
jmp @go
.endif

sub edx, 48

@go:
add eax, edx

inc esi

cmp esi, 8
jne @B

pop esi

mov edi, eax

call GetTickCount
sub eax, esi
sub edi, eax
xchg eax, edi

pop edi
pop esi

push 0
push eax
call SleepEx

@end:
push 0
call ExitProcess

db "Sleep Program v1.0 by BoR0", 32
db "This program waits for the specified milliseconds.", 32
db "Example: 'sleep.exe 000007D0' will sleep for 2 seconds.", 32
db "Please note that input is in hexadecimal.", 32

end start
