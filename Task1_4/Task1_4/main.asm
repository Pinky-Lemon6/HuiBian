.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

 .DATA
 lpFmt	db '%s',0ah,0dh,0
 lpFmt1	dd '%d',0
 lpFmt2 dd '%d',0
 LOWCASE db 'Data storage area LOWF',0
 MIDCASE db 'Data storage area MIDF',0
 HIGHCASE db 'Data storage area HIGHF',0
 SAMID DB 9 DUP(0)   ;每组数据的流水号（可以从1开始编号）
 SDA   DD 123      ;状态信息a
 SDB   DD -56      ;状态信息b
 SDC   DD 102      ;状态信息c
 SDF   DD ?      ;处理结果f
 LOWF  DD 3 DUP(0)
 MIDF  DD 3 DUP(0)
 HIGHF DD 3 DUP(0)

 .STACK 200
 .CODE
 main proc c
 mov eax,SDA
 imul eax,5
 add eax,SDB
 mov edx,SDC
 sub eax,edx
 add eax,100
 sar eax,7
 ;mov edi,128
 ;idiv edi
 mov SDF,eax
 cmp eax,100
 jg greater
 cmp eax,100
 jl litter
 cmp eax,100
 jz equal
equal:
 mov ECX,SDA
 mov MIDF,ECX
 mov ECX,SDB
 mov MIDF[4],ECX
 mov ECX,SDC
 mov MIDF[8],ECX
 invoke printf,offset lpFmt,offset MIDCASE
 jmp exit
greater:
 mov ECX,SDA
 mov HIGHF,ECX
 mov ECX,SDB
 mov HIGHF[4],ECX
 mov ECX,SDC
 mov HIGHF[8],ECX
 invoke printf,offset lpFmt,offset HIGHCASE
 jmp exit
litter:
 mov ECX,SDA
 mov LOWF,ECX
 mov ECX,SDB
 mov LOWF[4],ECX
 mov ECX,SDC
 mov LOWF[8],ECX
 invoke printf,offset lpFmt,offset LOWCASE
 jmp exit
exit:
 invoke ExitProcess,0
 main endp
 end