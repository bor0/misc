.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
rsrcType   db "BINARY", 0
rsrcLimit  dd 111

appName    db "BoR0's Extractor", 0
appText    db "Are you sure that you want", 13, 10, "to extract the components?", 0
appError   db "There was an error during extraction!", 0
appSuccess db "Successfully extracted all files.", 0

fileName   db 255 dup(0)

.data?
hInstance  dd ?
hResource  dd ?
hRsrcSize  dd ?
hRsrcData  dd ?

bytesWrit  dd ?

.code
start:
pushad
invoke MessageBox, 0, ADDR appText, ADDR appName, MB_YESNO+MB_ICONQUESTION
cmp eax, IDNO
je @err_end

invoke GetModuleHandle, 0
mov hInstance, eax

mov ebx, 100
mov esi, ebx
add esi, ebx

@loop:

invoke FindResource, hInstance, ebx, ADDR rsrcType
mov hResource, eax

invoke SizeofResource, hInstance, hResource
mov hRsrcSize, eax

invoke LoadResource, hInstance, hResource
mov hRsrcData, eax

invoke LoadString, hInstance, esi, ADDR fileName, 255

invoke DeleteFile, ADDR fileName
invoke CreateFile, ADDR fileName, GENERIC_WRITE, 0, 0, CREATE_NEW, 0, 0
invoke WriteFile, eax, hRsrcData, hRsrcSize, ADDR bytesWrit, 0

.IF eax == 0
invoke MessageBox, 0, ADDR appError, ADDR appName, MB_OK+MB_ICONERROR
jmp @err_end
.ENDIF

cmp ebx, rsrcLimit
je @end

inc ebx
inc esi
jmp @loop

@end:
invoke MessageBox, 0, ADDR appSuccess, ADDR appName, MB_OK+MB_ICONINFORMATION

@err_end:

popad
invoke ExitProcess, 0
end start
