;sinus draw by bor0 (designed for 1024x768)
;thanks goes to comrade (sine text scroller)

format PE GUI

section '.code' code readable executable

	push	0
	call	[GetDC]
	mov	[_hdc], eax

	@@:
	inc 	[_x]
	fild 	[_x]
	fdiv	[_freq]
	fsin
	fmul 	[_amp]
	fistp 	[_y]

	add 	[_y], 768/2 ;center

	push 	30
	push 	[_y]
	push 	[_x]
	push 	[_hdc]
	call 	[SetPixel]

	cmp 	[_x], 1024
	jne 	@B

	push	0
	call	[ExitProcess]

section '.data' data readable writeable

  _hdc     dd 0

  _x       dd 0
  _y       dd 0

  _amp     dq 08.5
  _freq    dq 10.0

section '.idata' import data readable writeable


  dd 0,0,0,RVA gdi_name,RVA gdi_table
  dd 0,0,0,RVA kernel_name,RVA kernel_table
  dd 0,0,0,RVA user_name,RVA user_table
  dd 0,0,0,0,0

  gdi_table:
    SetPixel dd RVA _SetPixel
    dd 0
  kernel_table:
    ExitProcess dd RVA _ExitProcess
    dd 0
  user_table:
    GetDC dd RVA _GetDC
    dd 0

  gdi_name db 'GDI32.DLL',0
  kernel_name db 'KERNEL32.DLL',0
  user_name db 'USER32.DLL',0

  _ExitProcess dw 0
    db 'ExitProcess',0
  _GetDC dw 0
    db 'GetDC',0
  _SetPixel dw 0
    db 'SetPixel',0
