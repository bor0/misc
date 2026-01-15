.486p
.model flat,stdcall

option casemap:none
include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\wsock32.inc
include \masm32\include\kernel32.inc
include \masm32\include\winmm.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\wsock32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\winmm.lib

.data
prefix   db "Message from SitnikNET on %d:%d (%d/%d/%d)",0
_cmd_alias db "open ", 34, "C:\bor0.mp3", 34, " alias media",0
_cmd_play  db "play media",0
_cmd_stop  db "close all", 0

.data?
buff      db 512 dup (?)
buff2     db 64 dup(?)
thetime   SYSTEMTIME <>

s1        SOCKET ?
s2        SOCKET ?
sin1      sockaddr_in <>
sin2      sockaddr_in <>
wsaData   WSADATA <>
temp      dd ?

.code

start:
    invoke WSAStartup,0101h,ADDR wsaData
    invoke socket,PF_INET,SOCK_STREAM,0
    mov s1,eax
    mov ax,AF_INET
    mov sin1.sin_family,ax
    xor eax,eax
    mov sin1.sin_addr,eax
    invoke htons,1337
    mov sin1.sin_port,ax
    invoke bind,s1,ADDR sin1,SIZEOF sockaddr_in
    cmp eax,SOCKET_ERROR
    jne @F
    invoke WSACleanup
    xor eax,eax
    ret
@@:
    invoke listen,s1,1

next_user:
    invoke closesocket,s2
    mov eax,SIZEOF sockaddr_in
    mov temp,eax
    invoke accept,s1,ADDR sin2,ADDR temp
    mov s2,eax

    mov eax,sin2.sin_addr ;get IP address of user
    invoke inet_ntoa,eax
    mov temp,eax

crecv:
    invoke RtlZeroMemory, ADDR buff, 511

    invoke recv,s2,ADDR buff,500,0
    or eax,eax
    jz next_user
    cmp eax,SOCKET_ERROR
    je next_user

    invoke GetLocalTime, ADDR thetime

    movzx eax, thetime.wYear
    push eax

    movzx eax, thetime.wMonth
    push eax

    movzx eax, thetime.wDay
    push eax

    movzx eax, thetime.wMinute
    push eax

    movzx eax, thetime.wHour
    push eax

    push offset prefix
    push offset buff2

    call wsprintf

    add esp, 01Ch

    invoke mciSendStringA,ADDR _cmd_alias,0,0,0
    invoke mciSendStringA,ADDR _cmd_play,0,0,0

    invoke MessageBox,NULL,ADDR buff,ADDR buff2, MB_OK or MB_ICONINFORMATION or MB_TOPMOST

    invoke mciSendStringA,ADDR _cmd_stop,0,0,0

    invoke send,s2,ADDR buff,1,0

    jmp next_user

killer:
    invoke closesocket,s1
    invoke closesocket,s2
    invoke WSACleanup
    xor eax,eax
    ret

end start

