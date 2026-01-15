.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\shell32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\wsock32.inc

includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\shell32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\wsock32.lib

WndProc    PROTO :HWND,:UINT,:WPARAM,:LPARAM

hostentStru STRUCT
  h_name      DWORD      ?
  h_alias     DWORD      ?
  h_addr      WORD       ?
  h_len       WORD       ?
  h_list      DWORD      ?
hostentStru ENDS

xsockaddr_in STRUCT
  sin_family  WORD        ?
  sin_port    WORD        ?
  sin_addr    DWORD       ?
  sin_zero    BYTE 8 dup (?)
xsockaddr_in ENDS

BGCOLOR       equ 0
TEXTCOLOR     equ 00ffffffh

.data
crlf equ 0Dh, 0Ah

theNeave      db "NEAVE", 0
hCaption      db "Neave's HShack - BoR0", 0
wsaerr        db "Winsock error!", 0

format  db "POST /games/games_score.php HTTP/1.1", crlf
        db "Accept: */*", crlf
        db "x-flash-version: 8,0,22,0", crlf
        db "Content-Type: application/x-www-form-urlencoded", crlf
        db "Content-Length: %d", crlf
        db "Accept-Encoding: gzip, deflate", crlf
        db "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)", crlf
        db "Host: www.neave.com", crlf
        db "Connection: Keep-Alive", crlf
        db "Cache-Control: no-cache"
lastfrm db crlf, crlf, 0

invader db "game=invaders&url=http://www.neave.com/games/invaders/invaders.swf&name=%s&score=%d", 0
pacman  db "game=pacman&url=http://www.neave.com/games/pacman/pacman.swf&name=%s&score=%d", 0
nblox   db "game=nblox&url=http://www.neave.com/games/nblox/nblox.swf&name=%s&score=%d", 0
snake   db "game=snake1&url=http://www.neave.com/games/snake/snake.swf&name=%s&score=%d", 0
astero  db "game=asteroids&url=http://www.neave.com/games/asteroids/asteroids.swf&name=%s&score=%d", 0

port    dd 80

myaddr  db "www.neave.com", 0
alldone db "Finished!", 0


.data?
hBlackBrush   dd ?
hInstance     dd ?
hIcon         dd ?
mybuffer      db 128 dup(?)
mybuffer2     db 512 dup(?)
wsadata       WSADATA <>
mysocket      dd ?
saServer      xsockaddr_in <>
lpHostEntry   hostentStru <>
dont          dd ?

bufname       db 16 dup(?)
score         dd ?

.code
HackGame PROC hWnd:DWORD

.IF eax == 1
mov eax, offset invader
.ELSEIF eax == 2
mov eax, offset pacman
.ELSEIF eax == 3
mov eax, offset nblox
.ELSEIF eax == 4
mov eax, offset snake
.ELSEIF eax == 5
mov eax, offset astero
.ELSE
jmp @end
.ENDIF

invoke wsprintf, ADDR mybuffer, eax, ADDR bufname, [score]
invoke lstrlen, ADDR mybuffer
invoke wsprintf, ADDR mybuffer2, ADDR format, eax
invoke lstrcat, ADDR mybuffer2, ADDR mybuffer
invoke lstrcat, ADDR mybuffer2, ADDR lastfrm

invoke WSAStartup, 101h, ADDR wsadata

.if eax!=NULL 
    invoke MessageBox, hWnd, ADDR wsaerr, ADDR hCaption, MB_ICONERROR
    jmp @end
.endif

invoke socket, AF_INET,SOCK_STREAM,0

.if eax!=INVALID_SOCKET
    mov mysocket, eax
.else
    invoke MessageBox, hWnd, ADDR wsaerr, ADDR hCaption, MB_ICONERROR
    jmp @end2
.endif

invoke htons, port
mov saServer.sin_port, ax
mov saServer.sin_family, AF_INET

invoke gethostbyname, addr myaddr 
mov eax,[eax+12]
mov eax,[eax]
mov eax,[eax]
mov saServer.sin_addr, eax

invoke connect, mysocket, ADDR saServer, sizeof sockaddr

.if eax==SOCKET_ERROR
    invoke MessageBox, hWnd, ADDR wsaerr, ADDR hCaption, MB_ICONERROR
    jmp @end3
.endif

invoke lstrlen, ADDR mybuffer2
invoke send, mysocket, ADDR mybuffer2, eax, 0

@@:
invoke recv, mysocket, ADDR mybuffer2, sizeof mybuffer2, 0
test eax, eax
je @done

cmp eax, -1
je @done

mov byte ptr [mybuffer2+eax], 0

invoke Sleep, 20

cmp dont, 1
je @B

invoke MessageBox, hWnd, ADDR mybuffer2, ADDR hCaption, MB_YESNO+MB_ICONINFORMATION
.IF eax == IDNO
inc dont
.ENDIF

jmp @B

@done:
invoke MessageBox, hWnd, ADDR alldone, ADDR hCaption, MB_ICONINFORMATION

@end3:
invoke closesocket, mysocket

@end2:
invoke WSACleanup

@end:
ret
HackGame ENDP

start:

invoke GetModuleHandle, NULL
mov hInstance, eax

invoke CreateSolidBrush, BGCOLOR
mov hBlackBrush, eax

invoke DialogBoxParam, hInstance, ADDR theNeave, 0, ADDR WndProc, 0

WndProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

.if uMsg == WM_INITDIALOG
invoke LoadIcon, hInstance, 500
invoke PostMessage, hWin, WM_SETICON, ICON_BIG, eax
invoke SetWindowText, hWin, ADDR hCaption
invoke SendDlgItemMessage, hWin, 2001, EM_LIMITTEXT, 128, 0

.elseif wParam == 4 && uMsg == WM_COMMAND
invoke GetDlgItemInt, hWin, 2003, 0, 0
mov [score], eax
invoke GetDlgItemText, hWin, 2002, ADDR bufname, 64
invoke GetDlgItemInt, hWin, 2001, 0, 0

push hWin
call HackGame

.elseif uMsg == WM_CTLCOLORDLG || uMsg == WM_CTLCOLORSTATIC
invoke SetTextColor, wParam, TEXTCOLOR
invoke SetBkColor, wParam, BGCOLOR
mov eax, hBlackBrush
ret

.elseif uMsg == WM_LBUTTONDOWN
invoke ReleaseCapture
invoke SendMessage, hWin, WM_NCLBUTTONDOWN, HTCAPTION, 0

.elseif uMsg == WM_CLOSE
invoke ExitProcess, 0

.else
xor eax, eax
ret

.endif
xor eax, eax
inc eax
ret

WndProc endp
end start