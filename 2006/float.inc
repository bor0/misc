.data
ten__1	dt	1.0e1
	dt	1.0e2
	dt	1.0e3
	dt	1.0e4
	dt	1.0e5
	dt	1.0e6
	dt	1.0e7
	dt	1.0e8
	dt	1.0e9
	dt	1.0e10
	dt	1.0e11
	dt	1.0e12
	dt	1.0e13
	dt	1.0e14
	dt	1.0e15

ten__16	dt	1.0e16
	dt	1.0e32
	dt	1.0e48
	dt	1.0e64
	dt	1.0e80
	dt	1.0e96
	dt	1.0e112
	dt	1.0e128
	dt	1.0e144
	dt	1.0e160
	dt	1.0e176
	dt	1.0e192
	dt	1.0e208
	dt	1.0e224
	dt	1.0e240

ten__256	dt	1.0e256
	dt	1.0e512
	dt	1.0e768
	dt	1.0e1024
	dt	1.0e1280
	dt	1.0e1536
	dt	1.0e1792
	dt	1.0e2048
	dt	1.0e2304
	dt	1.0e2560
	dt	1.0e2816
	dt	1.0e3072
	dt	1.0e3328
	dt	1.0e3584
	dt	1.0e4096
	dt	1.0e4352
	dt	1.0e4608
	dt	1.0e4864

tencool	dq	10.0

ten_1	dt	1.0e1
	dt	1.0e2
	dt	1.0e3
	dt	1.0e4
	dt	1.0e5
	dt	1.0e6
	dt	1.0e7
	dt	1.0e8
	dt	1.0e9
	dt	1.0e10
	dt	1.0e11
	dt	1.0e12
	dt	1.0e13
	dt	1.0e14
	dt	1.0e15

ten_16	dt	1.0e16
	dt	1.0e32
	dt	1.0e48
	dt	1.0e64
	dt	1.0e80
	dt	1.0e96
	dt	1.0e112
	dt	1.0e128
	dt	1.0e144
	dt	1.0e160
	dt	1.0e176
	dt	1.0e192
	dt	1.0e208
	dt	1.0e224
	dt	1.0e240

ten_256	dt	1.0e256
	dt	1.0e512
	dt	1.0e768
	dt	1.0e1024
	dt	1.0e1280
	dt	1.0e1536
	dt	1.0e1792
	dt	1.0e2048
	dt	1.0e2304
	dt	1.0e2560
	dt	1.0e2816
	dt	1.0e3072
	dt	1.0e3328
	dt	1.0e3584
	dt	1.0e4096
	dt	1.0e4352
	dt	1.0e4608
	dt	1.0e4864

FP_LESSTHAN	equ	01h
FP_EQUALTO	equ	40h

szTemp	db	18 dup (0)

	.code

StrToFloat	PROC	stdcall  public uses ebx, szIn: PTR BYTE, fpout: PTR QWORD
	LOCAL	sign: BYTE
	LOCAL	expsign: BYTE
	LOCAL	decimal: DWORD
	LOCAL	stat: WORD
	LOCAL	temp: WORD

    xor eax, eax
    mov [sign], al
    mov [expsign], al
    mov [decimal], -1

    fstcw [stat]
    mov [temp], 027fh
    fldcw [temp]

    mov esi, [szIn]
    mov al, [esi]

    .IF (al == '+')
	inc	esi
	mov	al, [esi]
    .ELSEIF (al == '-')
	inc	esi
	mov	[sign], 1
	mov	al, [esi]
    .ENDIF

    cmp al, 0
    je sdExit

    fclex
    xor ebx, ebx
    fldz
    xor ecx, ecx

cvtloop:
    cmp al, 'E'
    je doExponent
    cmp al, 'e'
    je doExponent

    .IF (al == '.')
	mov [decimal], ebx
    .ELSE
	sub al, '0'
	jb sdFinish
	cmp al, 9
	ja sdFinish
	mov [temp], ax
	fmul [tencool]
	fiadd [temp]
	inc ebx
    .ENDIF

    inc esi
    mov al, [esi]
    jnz cvtloop
    jmp sdFinish

doExponent:
    inc esi
    mov al, [esi]
    cmp al, 0
    jz sdFinish

    .IF	(al == '+')
	inc esi
	mov al, [esi]
    .ELSEIF (al == '-')
	inc esi
	mov [expsign], 1
	mov al, [esi]
    .ENDIF

    cmp al, 0
    jz sdFinish

expLoop:
    sub al, '0'
    jb sdFinish
    cmp al, 9
    ja sdFinish
    imul ecx, 10
    add ecx, eax

    inc esi
    mov al, [esi]
    jnz expLoop

sdFinish:
    .IF ([expsign] != 0)
	neg ecx
    .ENDIF
    mov eax, [decimal]
    .IF (eax != -1)
	sub ebx, eax
	sub ecx, ebx
    .ENDIF

    mov eax, ecx
    call PowerOf10

    .IF	([sign] != 0)
	fchs
    .ENDIF

    mov edi, [fpout]
    fstp qword ptr [edi]
    fwait

sdExit:
    fldcw [stat]
    mov eax, esi
    ret

StrToFloat	ENDP

PowerOf10	PROC	public

    mov ecx, eax
    .IF	(SDWORD PTR eax < 0)
	neg eax
    .ENDIF

    fld1

    mov dl, al
    and edx, 0fh
    .IF	(!ZERO?)
	lea edx, [edx+edx*4]
	fld ten__1[edx*2][-10]
	fmulp st(1), st
    .ENDIF

    mov dl, al
    shr dl, 4
    and edx, 0fh
    .IF (!ZERO?)
	lea edx, [edx+edx*4]
	fld ten__16[edx*2][-10]
	fmulp st(1), st
    .ENDIF

    mov dl, ah
    and edx, 1fh
    .IF (!ZERO?)
	lea edx, [edx+edx*4]
	fld ten__256[edx*2][-10]
	fmulp st(1), st
    .ENDIF

    .IF (SDWORD PTR ecx < 0)
	fdivp st(1), st
    .ELSE
	fmulp st(1), st
    .ENDIF

    ret

PowerOf10	ENDP

PowerOf10	proto

ten	dq	10.0
ten7	dq	1.0e6
ten17	dq	1.0e17
rounder	dq	5.0e10

FloatToBCD	PROC	public uses esi edi

    sub esp, 10

    fbstp [esp]

    lea esi, [esp+8]
    lea edi, [szTemp]
    mov ecx, 9

    .REPEAT
	mov al, [esi]
	dec esi
	rol ax, 12
	rol ah, 4
	and ax, 0f0fh
	add ax, 3030h
	mov [edi], ax
	add edi, 2
	dec ecx
    .UNTIL ZERO?

    add esp, 10
    ret

FloatToBCD	ENDP

FloatToStr	PROC	stdcall public USES esi edi, 
		fpin: QWORD, 
		szDbl: PTR CHAR

    LOCAL	iExp: DWORD
    LOCAL	stat: WORD
    LOCAL	mystat: WORD

	
    mov edi, [szDbl]

    .if	(dword ptr [fpin] == 0) && (dword ptr [fpin][4] == 0)
      mov byte ptr [edi], '0'
      mov byte ptr [edi][1], 0
      ret
    .endif


    .if	(sdword ptr [fpin][4] < 0)
      and byte ptr [fpin][7], 07fh
      mov byte ptr [edi], '-'
      inc edi
    .endif

    fclex
    fstcw [stat]
    mov [mystat], 027fh
    fldcw [mystat]

    fld [fpin]
    fld st(0)

    fxtract
    fstp st(0)
    fldlg2
    fmulp st(1), st
    fistp [iExp]

    .IF	([iExp] < 16)
      fld st(0)
      frndint
      fcomp st(1)
      fstsw ax
      .IF (ah & FP_EQUALTO)

	call FloatToBCD

	mov eax, 17
	mov ecx, [iExp]
	sub eax, ecx
	inc ecx
	lea esi, [szTemp][eax]

	.IF (byte ptr [esi] == '0')
	  inc esi
	  dec ecx
	.ENDIF

	rep movsb
	jmp ftsExit

      .ENDIF
    .ENDIF

    mov eax, 6
    sub eax, [iExp]
    call PowerOf10

    fcom [ten7]
    fstsw ax
    .IF (ah & 1)
      fmul [ten]
      dec iExp
    .ENDIF

    call FloatToBCD

    lea esi, [szTemp+11]

    mov ecx, iExp
    .IF (SDWORD PTR ecx >= -1) && (SDWORD PTR ecx <= 6)

      .IF (SDWORD PTR ecx == -1)
	mov byte ptr [edi], '0'
	inc edi
      .ENDIF

      inc ecx
      rep movsb
      mov byte ptr [edi], '.'
      inc edi
      mov ecx, 6
      sub ecx, [iExp]
      rep movsb

      .WHILE (byte ptr [edi-1] == '0')
	dec edi
      .ENDW

      .IF (byte ptr [edi-1] == '.')
	dec edi
      .ENDIF

      jmp ftsExit

    .ENDIF


    movsb
    mov byte ptr [edi], '.'
    inc edi
    movsd
    movsw

if 0

    .WHILE (byte ptr [edi][-1] == '0')
      dec edi
    .ENDW
endif

    mov byte ptr [edi], 'e'
    mov eax, [iExp]
    .IF (sdword ptr eax < 0)
      mov byte ptr [edi][1], '-'
      neg eax
    .ELSE
      mov byte ptr [edi][1], '+'
    .ENDIF

    mov ecx, 10

    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi][4], dl

    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi][3], dl

    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi][2], dl

    add edi, 5

ftsExit:
    mov byte ptr [edi], 0
    fldcw [stat]
    fwait

    ret

FloatToStr	ENDP
