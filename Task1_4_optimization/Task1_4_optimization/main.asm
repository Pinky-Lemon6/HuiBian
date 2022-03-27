.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 include winTimer.asm
 source struct
	SAMID DB 9 DUP(0)   ;每组数据的流水号（可以从1开始编号）
	SDA   DD ?      ;状态信息a
	SDB   DD ?      ;状态信息b
	SDC   DD ?      ;状态信息c
	SDF   DD ?      ;处理结果f
source ends
 .DATA
 lpFmt	db '%s',0ah,0dh,0
 lpFmt1	db '%d',0
 lpFmt2 db '%d',0ah,0dh,0
 LOWCASE db 'Data storage area LOWF',0
 MIDCASE db 'Data storage area MIDF',0
 HIGHCASE db 'Data storage area HIGHF',0
 SDA   DD ?      ;状态信息a
 SDB   DD ?      ;状态信息b
 SDC   DD ?      ;状态信息c
 DATA_N DD 10
 CAl_N DD 1000
 LOW_COUNT DD 0
 MID_COUNT DD 0
 HIGH_COUNT DD 0
 DATA_S source 3 DUP(<>)
 LOWF source 10000 DUP(<>)
 MIDF source 10000 DUP(<>)
 HIGHF source 10000 DUP(<>)
 
 .STACK 200
 .CODE
 main proc c
 invoke winTimer,0
 mov esi,0
outer_lopa:
 cmp esi,DATA_N
 jz exit
 invoke scanf,offset lpFmt1,offset SDA
 invoke scanf,offset lpFmt1,offset SDB
 invoke scanf,offset lpFmt1,offset SDC
 mov eax,SDA
 mov SDA,eax
 mov eax,SDB
 mov SDB,eax
 mov eax,SDC
 mov SDC,eax
 mov ebx,0
inner_lopa:
 cmp ebx,CAL_N
 jz inner_lopa_over
 call judge
 inc ebx
 jmp inner_lopa
inner_lopa_over:
 inc esi
 jmp outer_lopa
exit:
 invoke winTimer,1	;;结束计时并显示计时信息（毫秒）
 invoke ExitProcess,0
 main endp

judge proc
 mov ecx,SDA
 imul ecx,5
 add ecx,SDB
 mov eax,SDC
 sub ecx,eax
 add ecx,100
 sar ecx,7
 ;mov eax,ecx
 ;invoke printf,offset lpFmt1,ecx
 cmp ecx,100
 jg greater
 cmp ecx,100
 jl litter
 cmp ecx,100
 jz equal
equal:
 mov edi,offset MIDF
 mov eax,0
 imul eax,MID_COUNT,TYPE source
 add edi,eax
 mov EAX,SDA
 mov [edi].source.SDA,EAX
 mov EAX,SDB
 mov [edi].source.SDB,EAX
 mov EAX,SDC
 mov [edi].source.SDC,EAX
 mov EAX,ecx
 mov [edi].source.SDF,EAX
 inc MID_COUNT
 ;invoke printf,offset lpFmt2,[edi].source.SDF
 ;invoke printf,offset lpFmt,offset MIDCASE
 ;add edi,TYPE source
 jmp back
greater:
 mov edi,offset HIGHF
 mov eax,0
 imul eax,HIGH_COUNT,TYPE source
 add edi,eax
 mov EAX,SDA
 mov [edi].source.SDA,EAX
 mov EAX,SDB
 mov [edi].source.SDB,EAX
 mov EAX,SDC
 mov [edi].source.SDC,EAX
 mov EAX,ecx
 mov [edi].source.SDF,EAX
 inc HIGH_COUNT
 ;invoke printf,offset lpFmt2,[edi].source.SDF
 ;invoke printf,offset lpFmt,offset HIGHCASE
 ;add edi,TYPE source
 jmp back
litter:
 mov edi,offset LOWF
  mov eax,0
 imul eax,LOW_COUNT,TYPE source
 add edi,eax
 mov EAX,SDA
 mov [edi].source.SDA,EAX
 mov EAX,SDB
 mov [edi].source.SDB,EAX
 mov EAX,SDC
 mov [edi].source.SDC,EAX
 mov EAX,ecx
 mov [edi].source.SDF,EAX
 inc LOW_COUNT
 ;invoke printf,offset lpFmt2,[edi].source.SDF
 ;invoke printf,offset lpFmt,offset LOWCASE
 ;add edi,TYPE source
 jmp back
back:
 ret
 judge endp
 end