format PE GUI 4.0

include 'include/win32a.inc'

section '.code' code readable writeable executable

;-------------------------------------
; decryption algo resides here
; increase each opcode by 1

push eax

; strlen part
mov eax, -1

@@:inc eax

cmp byte ptr opcodes+eax, 0
jne @B

sub eax, 1
; strlen end

push ecx

; decryption algo
mov ecx, -1

@@:inc ecx
inc byte ptr opcodes+ecx

cmp ecx, eax
jne @B
; decryption end

pop ecx
pop eax
;-------------------------------------

;-------------------------------------
; code resides here
; decrease each opcode by 1

opcodes db\              ; main code
8Fh,\                    ; NOP
4Fh,\                    ; PUSH EAX
0B7h, 36h, 12h, 2, -1,\  ; MOV EAX, 31337
57h,\                    ; POP EAX
0C2h,\                   ; RET
0                        ; end of code
;-------------------------------------

; uncomment these lines to enable debugging
; with ollydbg.

invoke Sleep, 0
data import
library kernel32,'KERNEL32.DLL'
import kernel32,Sleep,'Sleep'
end data