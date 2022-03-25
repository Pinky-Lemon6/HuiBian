.686P 
.model flat, c
  ExitProcess proto stdcall :dword
  includelib  kernel32.lib
  printf      proto c :vararg
  includelib  libcmt.lib
  includelib  legacy_stdio_definitions.lib
.data
 lpFmt   db	"%d",0ah, 0dh, 0
.stack   200
.code
main proc  
; eax=0; for (ebx=1;ebx<=100;ebx++) eax=eax+ebx;
   mov  eax, 0     ;  (eax)=0，用于存放累加和
   mov  ebx, 1     ;  (ebx)=1，用于指示当前的加数
lp: cmp  ebx, 100  ; 连续两条指令，等同于 
                   ;  if (ebx>100) goto exit
    jg   exit
    add  eax, ebx  ;  (eax) = (eax) + (ebx)
    inc  ebx       ;  (ebx) = (ebx) +1
    jmp  lp        ;  goto lp
exit:
   invoke printf, offset lpFmt, eax
   invoke ExitProcess, 0
main  endp
end
