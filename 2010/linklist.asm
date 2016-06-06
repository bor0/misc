format PE GUI 4.0
entry start

; Written by Boro Sitnikovski (24.11.2010)
;
; list_init(DWORD list, LPSTR data)
; - Returns bytes from data copied.
; list_add(DWORD list, LPSTR data)
; - Returns bytes from data copied.
; list_print(DWORD list)
; - Returns the number of lists printed.
; list_free(DWORD list)
; - Returns 0 on SUCCESS

include 'win32a.inc'

datasize equ 512

link_list dd ?

section '.text' code readable executable

start:

push world1
push link_list
call list_init

push world2
push link_list
call list_add

push link_list
call list_print

push eax
push prefix
push world2
call [wsprintf]

push link_list
call list_free

invoke MessageBox,0,world2,prgrm,0
invoke ExitProcess,0

proc list_free list, data
mov eax, [list]
mov eax, [eax]
@@:
test eax, eax
je @F
mov edi, [eax]
invoke GlobalFree, eax
mov eax, edi
jmp @B
@@:
ret
endp

proc list_add list, data
mov eax, [list]
mov eax, [eax]
@@:
test eax, eax
je @F
mov edi, eax
mov eax, [eax]
jmp @B
@@:
invoke GlobalAlloc, 0, datasize+1
mov dword [eax], 0
mov [edi], eax
add eax, 4
invoke lstrcpyn, eax, [data], datasize-5
ret
endp

proc list_print list
mov eax, [list]
mov eax, [eax]
xor esi, esi
@@:
test eax, eax
je @F
push eax
add eax, 4
invoke MessageBox, 0, eax, prgrm, 0
inc esi
pop eax
mov eax, [eax]
jmp @B
@@:
mov eax, esi
ret
endp

proc list_init list, data
mov edi, [list]

invoke GlobalAlloc, 0, datasize+1
mov dword [edi], eax
mov dword [eax], 0
add eax, 4
invoke lstrcpyn, eax, [data], datasize-5

ret
endp

section '.data' data readable writeable

prgrm  db "BoR0's Linked List", 0
world1 db "Hello World!", 0
world2 db "Hi World, I was added to the list!", 0
prefix db "Total lists %d", 0

data import

library kernel32,'KERNEL32.DLL',\
	user32,'USER32.DLL'

import kernel32,\
       GlobalAlloc,'GlobalAlloc',\
       GlobalFree,'GlobalFree',\
       lstrcpyn,'lstrcpynA',\
       ExitProcess,'ExitProcess'

import user32,\
       MessageBox,'MessageBoxA',\
       wsprintf,'wsprintfA'

end data
