.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc

include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\comdlg32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\comdlg32.lib


.data
myapp db "BoR0's mini fmodplaya -- Select file to play", 0

mydll db "fmod.dll", 0
func1 db "_FSOUND_Init@12", 0
func2 db "_FMUSIC_LoadSong@4", 0
func3 db "_FMUSIC_PlaySong@4", 0
func4 db "_FMUSIC_StopSong@4", 0
func5 db "_FMUSIC_FreeSong@4", 0
func6 db "_FSOUND_Stream_Open@16", 0
func7 db "_FSOUND_Stream_Play@8", 0
func8 db "_FSOUND_Stream_Close@4", 0
func9 db "_FSOUND_Close@0", 0
filefilter db "All files (*.*)", 0, "*.*"

.data?
library dd ?
handle dd ?

FSOUND_Init         dd ?
FMUSIC_LoadSong     dd ?
FMUSIC_PlaySong     dd ?
FMUSIC_StopSong     dd ?
FMUSIC_FreeSong     dd ?
FSOUND_Stream_Open  dd ?
FSOUND_Stream_Play  dd ?
FSOUND_Stream_Close dd ?
FSOUND_Close        dd ?

ofn OPENFILENAME <>
filebuffer db 512 dup(?)

.code
start:
invoke LoadLibrary, ADDR mydll
test eax, eax
je @End2

mov [library], eax

invoke GetProcAddress, eax, ADDR func1
mov dword ptr [FSOUND_Init], eax
invoke GetProcAddress, [library], ADDR func2
mov dword ptr [FMUSIC_LoadSong], eax
invoke GetProcAddress, [library], ADDR func3
mov dword ptr [FMUSIC_PlaySong], eax
invoke GetProcAddress, [library], ADDR func4
mov dword ptr [FMUSIC_StopSong], eax
invoke GetProcAddress, [library], ADDR func5
mov dword ptr [FMUSIC_FreeSong], eax
invoke GetProcAddress, [library], ADDR func6
mov dword ptr [FSOUND_Stream_Open], eax
invoke GetProcAddress, [library], ADDR func7
mov dword ptr [FSOUND_Stream_Play], eax
invoke GetProcAddress, [library], ADDR func8
mov dword ptr [FSOUND_Stream_Close], eax
invoke GetProcAddress, [library], ADDR func9
mov dword ptr [FSOUND_Close], eax

mov ofn.lStructSize, SIZEOF OPENFILENAME
mov ofn.lpstrFilter, offset filefilter
mov ofn.lpstrFile, offset filebuffer
mov ofn.nMaxFile, 511
mov ofn.nFilterIndex, 1
mov ofn.Flags, OFN_HIDEREADONLY
mov ofn.lpstrTitle, offset myapp

invoke GetOpenFileName, ADDR ofn
test eax, eax
je @End

mov byte ptr [myapp+21], 0

push 0
push 32
push 44100
call FSOUND_Init

invoke CharLower, ADDR filebuffer
invoke lstrlen, ADDR filebuffer
sub eax, 4
add eax, offset filebuffer

cmp dword ptr [eax], 'dom.'
je @sequence
cmp dword ptr [eax], 'm3s.'
je @sequence
cmp dword ptr [eax], 'bsf.'
je @sequence
cmp dword ptr [eax], 'tgs.'
je @sequence
cmp dword ptr [eax], 'imr.'
je @sequence
cmp dword ptr [eax], 'mid.'
je @sequence
cmp word ptr [eax+2], 'ti'
je @sequence
cmp word ptr [eax+2], 'mx'
je @sequence

push 0
push 0
push 0
push offset filebuffer
call FSOUND_Stream_Open
mov [handle], eax

push [handle]
push 0
call FSOUND_Stream_Play
cmp eax, -1
je @End

invoke MessageBox, 0, ADDR filebuffer, ADDR myapp, MB_ICONINFORMATION

push [handle]
call FSOUND_Stream_Close

@End:
call FSOUND_Close
invoke FreeLibrary, [library]

@End2:
invoke ExitProcess, 0

@sequence:
push offset filebuffer
call FMUSIC_LoadSong
mov [handle], eax

push eax
call FMUSIC_PlaySong
test eax, eax
je @skip

invoke MessageBox, 0, ADDR filebuffer, ADDR myapp, MB_ICONINFORMATION

push [handle]
call FMUSIC_StopSong

@skip:
push [handle]
call FMUSIC_FreeSong

jmp @End
end start
