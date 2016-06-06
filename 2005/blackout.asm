.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\Comctl32.inc
include \masm32\include\comdlg32.inc
include \masm32\include\shell32.inc
include \masm32\include\oleaut32.inc

includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\Comctl32.lib
includelib \masm32\lib\comdlg32.lib
includelib \masm32\lib\shell32.lib
includelib \masm32\lib\oleaut32.lib


.data
sText db "This may cause damage to your monitor.", 13, 10, "If you run it press ESC to stop!",
         13, 10, 13, 10, "Are you sure you want to continue?", 0
sCapt db "Screen Flicker by BoR0", 0

.data?
hWnd dd ?
hDC  dd ?

.code
start:
invoke MessageBox, 0, ADDR sText, ADDR sCapt, MB_YESNO+MB_ICONQUESTION
cmp eax, IDYES
jne @off

invoke GetDesktopWindow
mov hWnd, eax

invoke GetWindowDC, eax
mov hDC, eax


@@:
invoke PatBlt, hDC, 0, 0, 1024, 768, WHITENESS
invoke Sleep, 10
invoke PatBlt, hDC, 0, 0, 1024, 768, BLACKNESS
jmp @B

@off:
invoke ReleaseDC, hWnd, hDC
invoke ExitProcess,0
end start
