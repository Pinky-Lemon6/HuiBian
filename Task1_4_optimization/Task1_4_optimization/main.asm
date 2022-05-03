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
 WELCOME db 'PLease input 10 sets of data:',0
 SDA   DD ?      ;状态信息a
 SDB   DD ?      ;状态信息b
 SDC   DD ?      ;状态信息c
 FLAG  DD ?
 DATA_N DD 10
 CAl_N DD 10000000
 LOW_COUNT DD 0
 MID_COUNT DD 0
 HIGH_COUNT DD 0
 LOWF source 100 DUP(<>)
 MIDF source 100 DUP(<>)
 HIGHF source 100 DUP(<>)
 
 .STACK 200
 .CODE
 main proc c
 invoke winTimer,0
 invoke printf,offset lpFmt,offset WELCOME
 mov esi,0
outer_lopa:
 cmp esi,DATA_N
 jz exit
 invoke scanf,offset lpFmt1,offset SDA
 invoke scanf,offset lpFmt1,offset SDB
 invoke scanf,offset lpFmt1,offset SDC
 mov ebx,0
inner_lopa:
 cmp ebx,CAL_N
 jz inner_lopa_over
 call judge
 inc ebx
 jmp inner_lopa
inner_lopa_over:
 inc esi
 cmp FLAG,0
 jg mov_g
 cmp FLAG,0
 jl mov_l
 cmp FLAG,0
 jz mov_m
mov_g:
 inc HIGH_COUNT
 jmp outer_lopa
mov_l:
 inc LOW_COUNT
 jmp outer_lopa
mov_m:
 inc MID_COUNT
 jmp outer_lopa
exit:
 invoke winTimer,1	;;结束计时并显示计时信息（毫秒）
 invoke ExitProcess,0
 main endp

judge proc
 mov ecx,SDA
 ;imul ecx,5
 sal ecx,2
 add ecx,SDA
 add ecx,SDB
 mov eax,SDC
 sub ecx,eax
 add ecx,100
 sar ecx,7
 ;mov eax,ecx
 ;cdq               ;将eax扩展为64位，解决溢出问题
 ;mov edi,128
 ;idiv edi
 ;div ecx,128
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
 mov FLAG,0
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
 mov FLAG,1
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
 mov FLAG,-1
 jmp back
back:
 ret
 judge endp
 end