include MsgBox.inc

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                     API Hashֵ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;MessageBoxA     1E380A6Ah
;LoadLibraryA    0C917432h
;ExitProcess     4FD18963h
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                ShellCode ģ�ͽ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;........................................................
;����ShellCode    ����δ֪ 
;JMP -> ShellCode
;........................................................
;GetKernelBase    ������֪ 
;........................................................
;GetPorcAddress   ������֪ 
;........................................................
;String           ����δ֪
;........................................................
; ���Ա䳤��ShellCode
;    ̧��ջ��, ��ȡ����ָ��
;    ���ShellCode����
;........................................................
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                 ShellCode �궨�岿��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DECODE_LEN       equ DeCodeEnd - DeCodeBegin                      ;���ܴ���ĳ���
ENCODE_LEN       equ ShellCodeEnd - MyGetKernelBegin              ;���ܴ���ĳ���
KERNEL_BASE_LEN  equ MyGetKernelEnd - MyGetKernelBegin            ;MyGetKernelBase���볤��
PROCADDR_LEN     equ MyGetProcAddressEnd - MyGetProcAddressBegin  ;GetProcAddress���볤��
SHELLCODE_LEN    equ ShellCodeEnd - ShellCodeBegin                ;ShellCode���볤��
STRING_LEN       equ STRING_END - STRING_BEGIN                    ;�ַ�������

dwGetKernelBase  =   DECODE_LEN - 5                               ;GetKernelBase  Offset
dwGetProcAddress =   DECODE_LEN + KERNEL_BASE_LEN - 5             ;GetProcAddress Offset


STACK_LEN        equ 100  ;̧��ջ���Ĵ�С


dwKernelBase     =   0h              ;KernelBaseƫ��
fnLoadLibrayA    =   4h              ;LoadLibraryAƫ��
hUser32          =   8h              ;hUser32ƫ��
fnMessageBox     =   0Ch             ;MessageBoxƫ��
fnExitProcess    =   10h             ;ExitProcessƫ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                     ���벿��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DeCodeBegin:
  ;�ض�λ
  call GET_EIP_1 
GET_EIP_1: 
  pop ebx
  
  ;���ܴ���[����ʹ��ebx�Ĵ���]
  ;......
  
  ;��ת��ShellCode��ʼ
  jmp ShellCodeBegin
DeCodeEnd:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                     MyGetKernelBase
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MyGetKernelBegin:
g_fn_GetKernelBase  db 064h,0A1h,18h,00h,00h,00h,8Bh,40h,30h,8Bh,40h,0Ch,8Bh,40h,0Ch,8Bh,00h,8Bh,00h,8Bh,40h,18h,0C3h
MyGetKernelEnd:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                     MyGetProcAddress
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MyGetProcAddressBegin:
g_fn_GetProcAddress db   55h,8Bh,0ECh,56h,53h,51h,83h,7Dh,08h,00h,74h,6Bh,8Bh,75h
                    db   08h,03h,76h,3Ch,8Dh,76h,78h,8Bh,36h,03h,75h,08h,8Bh,5Eh
                    db   20h,03h,5Dh,08h,33h,0C9h,8Bh,04h,8Bh,03h,45h,08h,51h,8Bh
                    db   0D0h,33h,0C0h,8Ah,0Ah,84h,0C9h,74h,11h,0Fh,0BEh,0C9h,0C1h
                    db   0C8h,07h,83h,0C2h,01h,03h,0C1h,8Ah,0Ah,84h,0C9h,75h,0EFh
                    db   59h,3Bh,45h,0Ch,74h,06h,41h,3Bh,4Eh,18h,72h,0D2h,3Bh,4Eh,18h
                    db   73h,22h,8Bh,5Eh,24h,03h,5Dh,08h,0Fh,0B7h,04h,4Bh,3Bh,46h
                    db   14h,73h,13h,8Bh,5Eh,1Ch,03h,5Dh,08h,8Bh,04h,83h,03h,45h
                    db   08h,59h,5Bh,5Eh,0C9h,0C2h,08h,00h,33h,0C0h,59h,5Bh,5Eh
                    db   0C9h,0C2h,08h,00h
MyGetProcAddressEnd:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                     String
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
STRING_BEGIN:
szUser32 db 'User32.dll',0
szHello  db 'Hello',0
szName   db 'Bingghost',0

USER32_LEN = szHello - szUser32
HELLO_LEN  = szName - szHello
NAME_LEN   = STRING_END - szName
lpszUser32       =   dwGetProcAddress +  PROCADDR_LEN             ;lpszUser32
lpszHello        =   lpszUser32 + USER32_LEN                      ;lpszHello
lpszName         =   lpszHello + HELLO_LEN                        ;lpName   
STRING_END:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                     ShellCode 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ShellCodeBegin:
  ;����ջ�ռ� ����ջ����
  sub  esp,STACK_LEN
  push ebp
  mov  ebp,esp
  
  ;�õ�Kernel32.dll�Ļ���ַ
  lea eax,[ebx + dwGetKernelBase]
  call eax
  or eax,eax
  jz Exit_ShellCode
  mov dword ptr [ebp + dwKernelBase],eax
  
  ;���������� �õ�LoadLibraryA��ַ
  push 0C917432h
  push dword ptr [ebp + dwKernelBase]
  lea  eax,[ebx + dwGetProcAddress]
  call eax
  or   eax,eax
  jz   Exit_ShellCode
  mov dword ptr [ebp + fnLoadLibrayA],eax
    
  ;����User32.dll
  lea eax,[ebx + lpszUser32]
  push eax
  call dword ptr [ebp + fnLoadLibrayA]
  or eax,eax
  jz Exit_ShellCode
  mov dword ptr [ebp + hUser32],eax

  ;��ȡMessage��ַ
  push 1E380A6Ah
  push dword ptr [ebp + hUser32]
  lea  eax,[ebx + dwGetProcAddress]
  call eax
  or   eax,eax
  jz   Exit_ShellCode
  mov  dword ptr [ebp + fnMessageBox],eax
  
  ;����MessageBox
  push MB_OK
  lea eax,[ebx + lpszHello]
  push eax
  lea eax,[ebx + lpszName]
  push eax
  push NULL
  call dword ptr [ebp + fnMessageBox]
  
Exit_ShellCode:
  ;��ȡExitProcess������ַ
  push 4FD18963h
  push dword ptr [ebp + dwKernelBase]
  lea  eax,[ebx + dwGetProcAddress]
  call eax
  or   eax,eax
  jz   ShellCodeEnd
  mov dword ptr [ebp + fnExitProcess],eax
  
  ;����ExitProcess
  push NULL
  call dword ptr [ebp + fnExitProcess]

ShellCodeEnd:
nop
nop
nop
nop
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                        End 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



ShowLen proc
  
  invoke crt_printf,L("Decode Len:",9h,"%d",0ah,0dh),DECODE_LEN
  invoke crt_printf,L("Encode Len:",9h,"%d",0ah,0dh),ENCODE_LEN
  invoke crt_printf,L("GetKernelBase Len:",9h,"%d",0ah,0dh),KERNEL_BASE_LEN
  invoke crt_printf,L("GetProcAddress Len:",9h,"%d",0ah,0dh),PROCADDR_LEN
  invoke crt_printf,L("ShellCode Len:",9h,"%d",0ah,0dh),SHELLCODE_LEN
  
  ret

ShowLen endp



main proc
  
  ;invoke ShowLen
  jmp DeCodeBegin

main endp

end main