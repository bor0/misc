.data 
moo      db "Easy conversion between STR<-->INT by bor0", 0 

mystring db "Mynumber equals to: " 
mynumber db "321", 0 

mystr2   db "Mynumber has been converted to decimal and is now being stored in eax.", 0 

mystr3   db "Mybuffer equals to: " 
mybuffer db 4 dup(0) 

.data? 
result dd ? 

.code 

start: 
invoke MessageBox,0,ADDR mystring,ADDR moo,0 

;;;;;;;;;STR to INT 
;;;;;;;;;;;;;;;;;;; 
movzx eax, byte ptr [mynumber] 
sub eax, 48 
mov ecx, 100 
mul ecx 
add result, eax 

movzx eax, byte ptr [mynumber+1] 
sub eax, 48 
mov ecx, 10 
mul ecx 
add result, eax 

movzx eax, byte ptr [mynumber+2] 
sub eax, 48 
add result, eax 

invoke MessageBox,0,ADDR mystr2,ADDR moo,0 
mov eax, result 

;;;;;;;;;INT to STR 
;;;;;;;;;;;;;;;;;;; 
xor edx, edx 

mov ecx, 100 
div ecx 

add eax, 48 
mov byte ptr [mybuffer], al 

mov eax, edx 
mov ecx, 10 
cdq 
div ecx 

add eax, 48 
mov byte ptr [mybuffer+1], al 

add edx, 48 
mov byte ptr [mybuffer+2], dl 

invoke MessageBox,0,ADDR mystr3,ADDR moo,0 

invoke ExitProcess, 0 
end start