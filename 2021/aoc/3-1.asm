; Build: nasm -f macho64 3-1.asm && gcc -o 3-1 3-1.o
; Debug: ndisasm -b 64 3-1.o

; Used the following as references:
; - http://6.s081.scripts.mit.edu/sp18/x86-64-architecture-guide.html
; - http://daft.getforge.io/
; - https://nasm.us/doc/nasmdoc4.html

global _main
extern _printf, _fopen, _fclose, _fgets, _atoi

; Some useful macros I built

%macro multiPush 1-*
  %rep %0 ; %0 is number of tokens
    push %1 ; first argument
    ; parameters rotated off the left end of the argument list reappear on the right, and vice versa
    %rotate 1
  %endrep
%endmacro

%macro multiPop 1-*
  %rep %0
    %rotate -1
    push %1
  %endrep
%endmacro

%macro openFile 2
  jmp %%skip

  ; Anything prefixed with %% is local to the macro
  %%fopen_read db "r", 0

  %%skip:
  multiPush rsi, rdi
  lea  rsi, [rel %%fopen_read]
  lea  rdi, [rel %1]
  call _fopen
  mov  [rel %2], rax
  multiPop rsi, rdi
%endmacro

%macro readLine 3
  multiPush rdi, rsi, rdx
  lea  rdi, [rel %2]
  mov  rsi, %3
  mov  rdx, [rel %1]
  call _fgets
  multiPop rdi, rsi, rdx
%endmacro

%macro movOrLea 2
  ; Cast the token to string
  %defstr param2 %2
  %substr firstchar param2 1

  %if firstchar == '&'
    %substr remainder param2 2,-1
    ; Cast back to token
    %deftok second remainder
    lea %1, second
  %else
    mov %1, %2
  %endif
%endmacro

%macro invokeOne 2
  push rdi
  movOrLea rdi, %2
  call %1
  pop rdi
%endmacro

%macro part1 3
  multiPush rdi, rax
  ; Part 1. Populate zerocount and total count
  xor rdi, rdi ; reset index
  
  %%again:
  lea rax, [rel %1]
  cmp byte [rax+rdi], 0
  je %%finish
  
  cmp byte [rax+rdi], '1'
  je %%itsone
  lea rax, [rel %2]
  inc qword [rel rax+(rdi*8)] ; rdi is increased by 1, but multiply by 8 for qword

  %%itsone:
  inc rdi
  
  jmp %%again

  %%finish:
  dec rdi
  mov qword [rel %3], rdi
  multiPop rdi, rax
%endmacro

%macro part2 4
  multiPush rdi, rax, rdx, rcx
  xor rdi, rdi ; reset index
  lea rax, [rel %1]
  lea rdx, [rel %2]
  
  %%again:
  cmp rdi, [rel %3]
  je %%finish
  
  mov rcx, [rel %4]
  sub rcx, [rel rax+(rdi*8)]
  mov qword [rel rdx+(rdi*8)], rcx
  
  inc rdi
  
  jmp %%again

  %%finish:
  multiPop rdi, rax, rdx, rcx
%endmacro

%macro populateGammaOrEpsilon 4
  multiPush rdi, rax, rdx, rcx
  xor rdi, rdi ; reset index
  lea rax, [rel %1]
  lea rdx, [rel %2]
  
  %%again:
  cmp rdi, [rel %3]
  je %%finish

  mov rcx, [rel rax+(rdi*8)]
  cmp rcx, [rel rdx+(rdi*8)]

  %if %4 == gamma
  jg %%skip
  %else
  jl %%skip
  %endif

  inc qword [rel %4]

  %%skip:
  shl qword [rel %4], 1
  inc rdi
  
  jmp %%again

  %%finish:
  shr qword [rel %4], 1
  multiPop rdi, rax, rdx, rcx
%endmacro

section .data
  filename db "input", 0
  buffer db 100 dup " "
  buffer2 db 100 dup " "
  file_pointer dq 0
  print_prefix db "%llu", 0
  final_sum_prefix db `\nFinal sum: %d\n`, 0

  zerocount dq 100 dup 0
  onecount dq 100 dup 0
  digitcount dq 0
  totalcount dq 0
  gamma dq 0
  epsilon dq 0
  product dq 0

section .text
_main:
; Init program
push rbp
mov rbp, rsp
sub rsp, 32

; Read the file
openFile filename, file_pointer

loop:
readLine file_pointer, buffer, 100
cmp rax, 0
je done

; Process logic goes here
; Part 1: populate zerocount and digitcount
part1 buffer, zerocount, digitcount

inc qword [rel totalcount]
jmp loop

done:

; Part 2. Populate onecount
part2 zerocount, onecount, digitcount, totalcount

populateGammaOrEpsilon zerocount, onecount, digitcount, gamma
populateGammaOrEpsilon zerocount, onecount, digitcount, epsilon

; Multiply them
mov rax, [rel gamma]
imul qword [rel epsilon]
mov qword [rel product], rax

; Print it
lea rdi, [rel print_prefix]
mov rsi, [rel product]
call _printf

invokeOne _fclose, [rel file_pointer]

leave
ret
