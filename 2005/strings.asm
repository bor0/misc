;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; strings functions by BoR0 ;
; copyright (c) 2004 August ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.386
.model flat, stdcall
option casemap:none

.code
start@12:
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strlen(buffer);
; returns the length of buffer without zeroterm

strlen PROC lpBuffer:DWORD

mov ecx, lpBuffer
xor eax, eax

@@:
cmp byte ptr [ecx+eax], 0
je @F

inc eax
jmp @B
@@:

ret

strlen ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strchardel(buffer, index);
; deletes a byte from the specified index
; returns the index

strchardel PROC uses edi lpBuffer:DWORD, lpIndex:DWORD
mov edi, lpBuffer
mov eax, lpIndex

@@:
cmp byte ptr [eax+edi-1], 0
je @F

mov cl, byte ptr [eax+edi]
mov byte ptr [eax+edi-1], cl

inc edi

jmp @B
@@:

ret

strchardel ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strrev(buffer, buffer2);
; reverts a string from buffer2 and places it into the buffer

strrev PROC uses esi edi lpBuffer:DWORD, lpSource:DWORD
mov edi, lpBuffer
mov esi, lpSource

invoke strlen, edi
dec eax

mov ecx, -1

@@:
inc ecx

push eax
sub eax, ecx

mov al, byte ptr [edi+eax]
mov byte ptr [esi+ecx], al

pop eax

cmp eax, ecx
je @F

jmp @B
@@:

ret
strrev ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strcpy(buffer, buffer2);
; copies the string from buffer2 to buffer
; returns the length

strcpy PROC uses edi esi lpBuffer:DWORD, lpSource:DWORD
mov edi, lpBuffer
mov esi, lpSource

xor eax, eax

@@:
mov cl, byte ptr [esi+eax]
mov byte ptr [edi+eax], cl

add eax, 1
test cl, cl
jnz @B

ret
strcpy ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strswap(buffer, place, place2);
; swaps bytes between place and place2
; returns the address to the string

strswap PROC uses esi edi ecx lpBuffer:DWORD, from:DWORD, to:DWORD

mov eax, lpBuffer

mov esi, from
mov edi, to

mov ch, byte ptr [eax+esi-1]
mov cl, byte ptr [eax+edi-1]

mov byte ptr [eax+edi-1], ch
mov byte ptr [eax+esi-1], cl

ret

strswap ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strupper(buffer);
; uppercase all characters
; returns the length of buffer

strupper PROC lpSource:DWORD

mov esi, lpSource
invoke strlen, esi

mov ecx, -1
@@: inc ecx

cmp byte ptr [esi+ecx], 97
jge @F

@back:
cmp ecx, eax
jne @B

ret

@@:
cmp byte ptr [esi+ecx], 122
jg @back
sub byte ptr [esi+ecx], 32
jmp @back
strupper ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strlower(buffer);
; lowercase all characters
; returns the length of buffer

strlower PROC lpSource:DWORD

mov esi, lpSource

invoke strlen, esi
mov ecx, -1
@@: inc ecx

cmp byte ptr [esi+ecx], 65
jge @F

@back:
cmp ecx, eax
jne @B

ret

@@:
cmp byte ptr [esi+ecx], 90
jg @back
add byte ptr [esi+ecx], 32
jmp @back
strlower ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; usage strdec2bin(buffer, int);
; converts an integer to a binary string
; returns the address to the buffer

strdec2bin PROC lpBuffer:DWORD, lpSource:DWORD

mov eax, lpBuffer

xor ecx, ecx
sub ecx, 1

@@:inc ecx

bt lpSource, ecx
adc byte ptr [eax+ecx], 48

cmp ecx, 31
jne @B

ret
strdec2bin ENDP
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

end start@12