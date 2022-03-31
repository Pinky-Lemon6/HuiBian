.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 copy_data PROTO:dword,:dword
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 source struct
	SAMID DB 9 DUP(0)   ;每组数据的流水号（可以从1开始编号）
	SDA   DD ?      ;状态信息a
	SDB   DD ?      ;状态信息b
	SDC   DD ?      ;状态信息c
	SDF   DD ?      ;处理结果f
source ends
 .DATA
 lpFmt_S1 db '%s',0ah,0dh,0
 lpFmt_S2 db '%s',0
 lpFmt1	db '%d',0
 lpFmt2 db '%d',0ah,0dh,0
 LOWCASE db 'Data storage area LOWF',0
 MIDCASE db 'Data storage area MIDF',0
 HIGHCASE db 'Data storage area HIGHF',0
 IN_USERNAME db 10 dup(0),0
 IN_PWD	db 10 dup(0),0
 WELCOME1 db 'Welcome to Use!Please Log in!',0
 WELCOME2 db 'Please input your data:',0
 MENU1 db 'Please input your user name:(No more than 10 characters)',0
 MENU2	db 'Please input your password:(No more than 10 characters)',0
 SUCCESS db 'OK!Welcome you:',0
 ERROR db 'Incorrect User name / Password!',0
 ATTEMPT db 'The number of attempts you have left is:',0
 SAVED_USERNAME db 'LISHIYU',0
 SAVED_PWD	db 'U202015351',0
 SDA   DD ?      ;状态信息a
 SDB   DD ?      ;状态信息b
 SDC   DD ?      ;状态信息c
 JUDGE1 dd 0
 JUDGE2 DB 0
 ATT_N db 0
 DATA_N DD 10
 LOW_COUNT DD 0
 MID_COUNT DD 0
 HIGH_COUNT DD 0
 LOWF source 10000 DUP(<>)
 MIDF source 10000 DUP(<>)
 HIGHF source 10000 DUP(<>)

 strcmp macro x,y
	local strcmp_start,strcmp_large,strcmp_little,strcmp_equ,strcmp_exit
	mov JUDGE1,0
	;push offset x
	;push offset y
	;push ebp
	;mov ebp,esp
	;push esi
	;push edi
	;push edx
	mov edi,offset y
	mov esi,offset x
 strcmp_start:
    mov dl,[edi]
	cmp dl,[esi]
	ja strcmp_large
	jb strcmp_little
	cmp dl,0
	je strcmp_equ
	inc esi
	inc edi
	jmp strcmp_start
 strcmp_large:
    mov eax,1
	jmp strcmp_exit
 strcmp_little:
    mov eax,-1
	jmp strcmp_exit
 strcmp_equ:
    mov eax,0
 strcmp_exit:
	or JUDGE1,eax
    ;pop edx
	;pop edi
	;pop esi
	;pop ebp
	endm

 .STACK 200
 .CODE
 main proc c
	mov ATT_N,3
	invoke printf,offset lpFmt_S1,offset WELCOME1
 function1:
	cmp ATT_N,0
	jz exit
	invoke printf,offset lpFmt_S2,offset ATTEMPT
	invoke printf,offset lpFmt2,ATT_N
	input_1:
		invoke printf,offset lpFmt_S1,offset MENU1
		invoke scanf,offset lpFmt_S2,offset IN_USERNAME
		invoke printf,offset lpFmt_S1,offset MENU2
		invoke scanf,offset lpFmt_S2,offset IN_PWD
		;push offset SAVED_USERNAME
		;push offset IN_USERNAME
		strcmp SAVED_USERNAME,IN_USERNAME
		;add esp,8
		;push offset SAVED_PWD
		;push offset IN_PWD
		strcmp SAVED_PWD,IN_PWD
		;add esp,8
		cmp JUDGE1,0
		jnz input_1again
		cmp JUDGE1,0
		jz function2
	input_1again:
		invoke printf,offset lpFmt_S1,offset ERROR
		dec ATT_N
		jmp function1
 function2:
		invoke printf,offset lpFmt_S2,offset SUCCESS
		invoke printf,offset lpFmt_S2,offset IN_USERNAME
		invoke printf,offset lpFmt_S1,offset WELCOME2
		mov esi,0
	input_2:
		cmp esi,DATA_N
		jz menu2_again
		;invoke winTimer,0
		invoke scanf,offset lpFmt1,offset SDA
		invoke scanf,offset lpFmt1,offset SDB
		invoke scanf,offset lpFmt1,offset SDC
		call judge
		inc esi
		jmp input_2
	menu2_again:
		invoke scanf,offset lpFmt_S2,offset JUDGE2
	cal_f proc
		mov eax,SDA
		mov SDA,eax
		mov eax,SDB
		mov SDB,eax
		mov eax,SDC
		mov SDC,eax
		mov ecx,SDA
		imul ecx,5
		add ecx,SDB
		mov eax,SDC
		sub ecx,eax
		add ecx,100
		sar ecx,7
		ret
	cal_f endp
	
	copy_data proc buf:dword,n:dword
		mov edi,buf
		mov eax,0
		imul eax,n,TYPE source
		add edi,eax
		mov EAX,SDA
		mov [edi].source.SDA,EAX
		mov EAX,SDB
		mov [edi].source.SDB,EAX
		mov EAX,SDC
		mov [edi].source.SDC,EAX
		mov EAX,ecx
		mov [edi].source.SDF,EAX
		ret
		copy_data endp

	judge proc
	    call cal_f
		;mov ecx,SDA
		;imul ecx,5
		;add ecx,SDB
		;mov eax,SDC
		;sub ecx,eax
		;add ecx,100
		;sar ecx,7
		;mov eax,ecx
		;invoke printf,offset lpFmt1,ecx
		cmp ecx,100
		jg greater
		cmp ecx,100
		jl litter
		cmp ecx,100
		jz equal
	equal:
		invoke copy_data,offset MIDF,MID_COUNT
		inc MID_COUNT
		;invoke printf,offset lpFmt2,[edi].source.SDF
		;invoke printf,offset lpFmt,offset MIDCASE
		;add edi,TYPE source
		jmp back
	greater:
		invoke copy_data,offset HIGHF,HIGH_COUNT
		inc HIGH_COUNT
		;invoke printf,offset lpFmt2,[edi].source.SDF
		;invoke printf,offset lpFmt,offset HIGHCASE
		;add edi,TYPE source
		jmp back
	litter:
		invoke copy_data,offset LOWF,LOW_COUNT
		inc LOW_COUNT
		;invoke printf,offset lpFmt2,[edi].source.SDF
		;invoke printf,offset lpFmt,offset LOWCASE
		;add edi,TYPE source
		jmp back
	back:
		ret
	judge endp
 exit:
	invoke ExitProcess,0
 main endp
 end
