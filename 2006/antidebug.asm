.486                                ; create 32 bit code
.model flat, stdcall                ; 32 bit memory model
option casemap :none                ; case sensitive
  
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib


.data
NTDLL db "ntdll.dll", 0
ZWSET db "ZwSetInformationThread", 0

ThreadBasicInformation EQU 0
ThreadTimes EQU 1
ThreadPriority EQU 2
ThreadBasePriority EQU 3
ThreadAffinityMask EQU 4
ThreadImpersonationToken EQU 5
ThreadDescriptorTableEntry EQU 6
ThreadEnableAlignmentFaultFixup EQU 7
ThreadEventPair_Reusable EQU 8
ThreadQuerySetWin32StartAddress EQU 9
ThreadZeroTlsCell EQU 10
ThreadPerformanceCount EQU 11
ThreadAmILastThread EQU 12
ThreadIdealProcessor EQU 13
ThreadPriorityBoost EQU 14
ThreadSetTlsArrayAddress EQU 15
ThreadIsIoPending EQU 16
ThreadHideFromDebugger EQU 17
ThreadBreakOnTermination EQU 18
MaxThreadInfoClass EQU 19


.code

start:
invoke GetCurrentThread
mov edx, eax
push edx

invoke GetModuleHandle, ADDR NTDLL
invoke GetProcAddress, eax, ADDR ZWSET

pop edx

push 0
push 0
push ThreadHideFromDebugger
push edx
call eax

invoke MessageBox, 0, ADDR NTDLL, ADDR ZWSET, MB_ICONINFORMATION

invoke ExitProcess, 0

end start
