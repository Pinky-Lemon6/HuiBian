.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 include winTimer.asm
 source struct
	SAMID DB 9 DUP(0)   ;ÿ�����ݵ���ˮ�ţ����Դ�1��ʼ��ţ�
	SDA   DD ?      ;״̬��Ϣa
	SDB   DD ?      ;״̬��Ϣb
	SDC   DD ?      ;״̬��Ϣc
	SDF   DD ?      ;������f
source ends
 .DATA
 lpFmt	db '%s',0ah,0dh,0
 lpFmt1	db '%d',0
 LOWCASE db 'Data storage area LOWF',0
 MIDCASE db 'Data storage area MIDF',0
 HIGHCASE db 'Data storage area HIGHF',0
 SDA   DD ?      ;״̬��Ϣa
 SDB   DD ?      ;״̬��Ϣb
 SDC   DD ?      ;״̬��Ϣc
 DATA_N DD 3
 LOWF source 30 DUP(<>)
 MIDF source 30 DUP(<>)
 HIGHF source 30 DUP(<>)
 CAl_N DD 10

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
 invoke winTimer,1	;;������ʱ����ʾ��ʱ��Ϣ�����룩
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
 add edi,TYPE source
 mov EAX,SDA
 mov [edi].source.SDA,EAX
 mov EAX,SDB
 mov [edi].source.SDB,EAX
 mov EAX,SDC
 mov [edi].source.SDC,EAX
 mov EAX,ecx
 mov [edi].source.SDF,EAX
 invoke printf,offset lpFmt1,[edi].source.SDF
 invoke printf,offset lpFmt,offset MIDCASE
 jmp back
greater:
 mov edi,offset HIGHF
 add edi,TYPE source
 mov EAX,SDA
 mov [edi].source.SDA,EAX
 mov EAX,SDB
 mov [edi].source.SDB,EAX
 mov EAX,SDC
 mov [edi].source.SDC,EAX
 mov EAX,ecx
 mov [edi].source.SDF,EAX
 invoke printf,offset lpFmt1,[edi].source.SDF
 invoke printf,offset lpFmt,offset HIGHCASE
 jmp back
litter:
 mov edi,offset LOWF
 add edi,TYPE source
 mov EAX,SDA
 mov [edi].source.SDA,EAX
 mov EAX,SDB
 mov [edi].source.SDB,EAX
 mov EAX,SDC
 mov [edi].source.SDC,EAX
 mov EAX,ecx
 mov [edi].source.SDF,EAX
 invoke printf,offset lpFmt1,[edi].source.SDF
 invoke printf,offset lpFmt,offset LOWCASE
 jmp back
back:
 ret
 judge endp

 end