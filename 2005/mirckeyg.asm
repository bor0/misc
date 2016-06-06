GenerateKey PROC myUser:LPSTR

;----------------------------------------------------------------
; mIRC serial number generator by BoR0
;----------------------------------------------------------------
; Written (actually translated) from www.8ung.at/zoomski/reveng/mIRC-6.16
;
; Greetings to Jolt. Nice tutorial there man! :-)
;
; I didn't reverse mIRC's algorithm, I just translated what Jolt did to asm.
;
; It was hell for me, believe me. Almost 2 hours of UNSTOPPABLE thinking.
; Converting C/C++ to ASM is a HELL. This is the last I ever do (NOT) ;)
; That math stuff was KILLING me. Anyhow, I also did stupid mistakes..
;
; Username characters required: 4
; Serial number syntax: %d-%d
; Serial number output: EAX-EDX
;
; Example:
; Username: BoR0
; Serial:   528-43296
;           EAX:EDX
;
; So for BoR0 it would return 528 in EAX and 43296 in EDX (decimal).
; Use any algo to convert decimal to string (wsprintf(); might do it).
;
; EAX part:
; for(i=3;i<strlen(myUser);i++)
; sum1+=myUser[i]*magictable[(i-3)%39]
;
; EDX part:
; for(i=3;i<strlen(myUser);i++)
; sum2+=myUser[i]*myUser[i-1]*magictable[(i-3)%39]
;
; Returns ECX as string length.
;----------------------------------------------------------------

.data
magictable db 0Bh, 06h, 11h, 0Ch, 0Ch, 0Eh, 05h, 0Ch
           db 10h, 0Ah, 0Bh, 06h, 0Eh, 0Eh, 04h, 0Bh
           db 06h, 0Eh, 0Eh, 04h, 0Bh, 09h, 0Ch, 0Bh
           db 0Ah, 08h, 0Ah, 0Ah, 10h, 08h, 04h, 06h
           db 0Ah, 0Ch, 10h, 08h, 0Ah, 04h, 10h, 00h

.data?
sum1       dd ?
sum2       dd ?

.code
; EAX:EDX used for math (div/mul)
; EBX used as a source for div/mul
; ECX used as length
; EDI used as a pointer to the username
; ESI used as loop
; results in memory sum1/sum2 then moved to EDX/EAX

push edi
mov edi, myUser
xor ecx, ecx

@@:
cmp byte ptr [edi+ecx], 0 ; string length algo
je @F

inc ecx
jmp @B
@@:

cmp ecx, 4
jl retnow

; if no jump success (user is bigger than 4)
; start the job from here
xor edx, edx

mov sum1, 0
mov sum2, 0

push ebx
push esi

mov esi, 3 ; for(i=3
@@:
cmp ecx, esi ; i<strlen(myUser)
je @F

mov eax, esi
sub eax, 3 ; (i-3)

mov ebx, 39 ; (i-3)%39
cdq
div ebx

movzx ebx, byte ptr [magictable+edx] ; magictable[(i-3)%39)]
movzx eax, byte ptr [edi+esi] ; myUser[i]
mul ebx ; myUser[i]*magictable[(i-3)%39)]

add sum1, eax ; sum1+=myUser[i]*magictable[(i-3)%39)]

movzx ebx, byte ptr [edi+esi-1] ; myUser[i-1]
mul ebx ; myUser[i-1]*myUser[i]*magictable[(i-3)%39)]

add sum2, eax ; sum2+=myUser[i]*myUser[i-1]*magictable[(i-3)%39)]

inc esi ; i++)
jmp @B
@@:

mov eax, sum1 ; EAX=sum1
mov edx, sum2 ; EDX=sum2

pop esi
pop ebx

retnow:
pop edi
ret
GenerateKey ENDP