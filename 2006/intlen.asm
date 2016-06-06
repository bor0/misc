.data 
mynumber dd 9140374 

.code 
start: 
push edi 

mov eax, mynumber 
xor edi, edi 

@@: 
xor edx, edx 

mov ecx, 10 
div ecx 

test eax, eax 
je @F 

inc edi 

jmp @B 

@@: 
inc edi ; edi=7 

pop edi 

invoke ExitProcess, 0 
end start