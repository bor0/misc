;alias jp "+duck ; +jump ; wait; -jump ;-duck" ; bind mouse4 jp ; bind mouse5 jp

format PE GUI
entry start

weapon_scout  equ 0BD30h  ;weapon_scout-baseaddr
item_longjump equ 7CA90h  ;item_longjump-baseaddr

TH32CS_SNAPMODULE  equ 8
PROCESS_VM_RW      equ 1F0FFFh
MB_ICONERROR       equ 16
MB_ICONINFORMATION equ 64

section '.code' code readable executable

  start:

	push	myWindow
	push	0
	call 	[FindWindow]

	mov 	byte ptr myWindow+14, 32

	push	temp_id
	push	eax
	call 	[GetWindowThreadProcessId]

	push	[temp_id]
	push	TH32CS_SNAPMODULE
	call	[CreateToolhelp32Snapshot]

	mov 	dword ptr handle, eax

	push	lpme
	push	[handle]
	call	[Module32First]

	@@:
	push 	lpme
	push 	[handle]
	call	[Module32Next]

	test 	eax, eax
	je	@error

	push	szExePath
	call	[lstrlen]

	push	szExePath-7
	pop	edx
	add	edx, eax

	push 	mydll
	push	edx
	call	[lstrcmp]
	test	eax, eax
	jne	@B

	push	esi
	push	edi

	mov	esi, [modBaseAddr]
	mov	edi, esi

	add	esi, weapon_scout
	add	edi, item_longjump

	push	[handle]
	call	[CloseHandle]

	push	[temp_id]
	push	0
	push	PROCESS_VM_RW
	call	[OpenProcess]

	mov	dword ptr handle, eax

	push	temp_id
	push	1
	push	hax
	push	esi
	push	[handle]
	call	[ReadProcessMemory]

	cmp	byte ptr hax, 56h
	mov	byte ptr hax, 56h
	mov 	dword ptr temp_id, 0824748Bh
	jne	@thenrollback

	mov	byte ptr hax, 0E9h

	mov 	eax, edi
	sub	eax, esi
	sub	eax, 5

	mov dword ptr temp_id, eax

	@thenrollback:
	push	temp_id
	push	5
	push	hax
	push	esi
	push	[handle]
	call	[WriteProcessMemory]

	mov	edi, eax

	push	[handle]
	call	[CloseHandle]

	test	edi, edi

	pop	edi
	pop	esi

	je	@error2

	push	MB_ICONINFORMATION
	push	myWindow
	push	success
	push	0
	call	[MessageBox]

	@end:

	push	0
	call	[ExitProcess]


	@error:
	push	MB_ICONERROR
	push	myWindow
	push	error
	push	0
	call	[MessageBox]

	jmp 	@end

	@error2:
	push	MB_ICONERROR
	push	myWindow
	push	error2
	push	0
	call	[MessageBox]

	jmp 	@end


section '.data' data readable writeable

  myWindow db "Counter-Strike", 0, "paxor by BoR0", 0
  mydll    db "\mp.dll", 0

  success  db "Succesfully switched 'weapon_scout' with 'item_longjump'.", 13, 10
           db "Make sure you restart round/game. To jump fast, press crouch+jump!", 0

  error    db "Couldn't find mp.dll loaded. Make sure correct process is loaded!", 0
  error2   db "Couldn't write to process. Make sure you have correct rights!", 0

  lpme: ;MODULE32ENTRY
    dwSize          dd 224h
    th32ModuleID    dd ?
    th32ProcessID   dd ?
    GlblcntUsage    dd ?
    ProccntUsage    dd ?
    modBaseAddr     dd ?
    modBaseSize     dd ?
    hModule         dd ?
    szModule        db 256 dup(?)
    szExePath       db 260 dup(?)

  hax      db ?
  temp_id  dd ?
  handle   dd ?

section '.idata' import data readable writeable

  dd 0,0,0,RVA kernel_name,RVA kernel_table
  dd 0,0,0,RVA user_name,RVA user_table
  dd 0,0,0,0,0

  kernel_table:
    CloseHandle              dd RVA _CloseHandle
    CreateToolhelp32Snapshot dd RVA _CreateToolhelp32Snapshot
    ExitProcess              dd RVA _ExitProcess
    lstrcmp                  dd RVA _lstrcmp
    lstrlen                  dd RVA _lstrlen
    Module32First            dd RVA _Module32First
    Module32Next             dd RVA _Module32Next
    OpenProcess              dd RVA _OpenProcess
    ReadProcessMemory        dd RVA _ReadProcessMemory
    WriteProcessMemory       dd RVA _WriteProcessMemory
    dd 0

  user_table:
    MessageBox               dd RVA _MessageBoxA
    FindWindow               dd RVA _FindWindow
    GetWindowThreadProcessId dd RVA _GetWindowThreadProcessId
    dd 0

  kernel_name db 'KERNEL32.DLL',0
  user_name db 'USER32.DLL',0

  _CloseHandle dw 0
    db 'CloseHandle',0
  _CreateToolhelp32Snapshot dw 0
    db 'CreateToolhelp32Snapshot', 0
  _ExitProcess dw 0
    db 'ExitProcess',0
  _FindWindow dw 0
    db 'FindWindowA',0
  _GetWindowThreadProcessId dw 0
    db 'GetWindowThreadProcessId',0
  _lstrcmp dw 0
    db 'lstrcmpA',0
  _lstrlen dw 0
    db 'lstrlenA',0
  _MessageBoxA dw 0
    db 'MessageBoxA',0
  _Module32First dw 0
    db 'Module32First',0
  _Module32Next dw 0
    db 'Module32Next',0
  _OpenProcess dw 0
    db 'OpenProcess',0
  _ReadProcessMemory dw 0
    db 'ReadProcessMemory',0
  _WriteProcessMemory dw 0
    db 'WriteProcessMemory',0
