; BoR0's Advanced Binomials Formula
; ------------------------------------
; you can use it freely in your codes
; meanwhile sending respectful credits
; to the author.

.386
.model flat, stdcall
option casemap :none

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.code
binomials PROC a, b
;a^3
mov eax, a
mov edx, a
mul edx
mov edx, a
mul edx
mov ecx, eax

;3*a^2*b
mov eax, a
mov edx, a
mul edx
mov edx, b
mul edx
mov edx, 3
mul edx
add ecx, eax

;3*a*b^2
mov eax, b
mov edx, b
mul edx
mov edx, a
mul edx
mov edx, 3
mul edx
add ecx, eax

;b^3
mov eax, b
mov edx, b
mul edx
mov edx, b
mul edx
add eax, ecx

ret
;(a+b)^3 = a^3 + 3*a^2*b + 3*a*b^2 + b^3
binomials ENDP

start:
invoke binomials, 100, 301 ;(100+301)^3=64481201
invoke ExitProcess, 0
end start
