;编写者：李石峪 U202015351
;本程序由4个模块组成：1.main.asm 2.Print_F.asm 3.Copy_Data.asm 4.winTimer.asm
;本模块为主模块 main.asm，作为主函数模块
;本模块包含以下子程序：main、judge、cal_f
.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 copy_data PROTO:dword,:dword
 print_F PROTO:dword,:dword
 winTimer PROTO stdcall,:dword
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 public SDA,SDB,SDC,SAMID
 public lpFmt_S1,lpFmt_S2,lpFmt2
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
 SAVED_USERNAME db 'LISHIYU',0
 SAVED_PWD	db 'U202015351',0
 IN_USERNAME db 10 dup(0),0
 IN_PWD	db 10 dup(0),0
 WELCOME1 db 'Welcome to Use!Please Log in!',0
 WELCOME2 db 'Please input 100 sets of data:',0
 MENU1 db 'Please input your user name:(No more than 10 characters)',0
 MENU2	db 'Please input your password:(No more than 10 characters)',0
 SUCCESS db 'OK!Welcome you:',0
 ERROR db 'Incorrect User name / Password!',0
 ATTEMPT db 'The number of attempts you have left is:',0
 NEXT db 'Please press "R" to input again or press "Q" to exit:',0

 THANK db 'Thanks for your use!',0
 SAMID db 9 DUP(0)  ;当前数据编号
 SDA   DD ?      ;状态信息a
 SDB   DD ?      ;状态信息b
 SDC   DD ?      ;状态信息c
 JUDGE1 dd 0
 ATT_N db 0
 DATA_N DD 100
 LOW_COUNT DD 0
 MID_COUNT DD 0
 HIGH_COUNT DD 0
 LOWF source 1000 DUP(<>)
 MIDF source 1000 DUP(<>)
 HIGHF source 1000 DUP(<>)
 CHOICE1 db 'R',0
 CHOICE2 db 'Q',0
 CHOICE db 0

 strcmp macro x,y
	local strcmp_start,strcmp_large,strcmp_little,strcmp_equ,strcmp_exit
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
	endm

 .STACK 200
 .CODE
 main proc c
	mov ATT_N,3
	invoke printf,offset lpFmt_S1,offset WELCOME1
 function1:
	cmp ATT_N,0
	jz exit
	mov JUDGE1,0
	invoke printf,offset lpFmt_S2,offset ATTEMPT
	invoke printf,offset lpFmt2,ATT_N
	input_1:
		invoke printf,offset lpFmt_S1,offset MENU1
		invoke scanf,offset lpFmt_S2,offset IN_USERNAME
		invoke printf,offset lpFmt_S1,offset MENU2
		invoke scanf,offset lpFmt_S2,offset IN_PWD
		strcmp SAVED_USERNAME,IN_USERNAME
		strcmp SAVED_PWD,IN_PWD
		cmp JUDGE1,0
		jnz input_1again
		cmp JUDGE1,0
		jz function2
	input_1again:
		invoke printf,offset lpFmt_S1,offset ERROR
		dec ATT_N
		jmp function1
 function2:
		invoke winTimer,0
		invoke printf,offset lpFmt_S2,offset SUCCESS
		invoke printf,offset lpFmt_S1,offset IN_USERNAME
		invoke printf,offset lpFmt_S1,offset WELCOME2
		mov ebx,0
	input_2:
		cmp ebx,DATA_N
		jz output_2
		invoke scanf,offset lpFmt1,offset SDA
		invoke scanf,offset lpFmt1,offset SDB
		invoke scanf,offset lpFmt1,offset SDC
		inc SAMID
		call judge
		inc ebx
		jmp input_2
	output_2:
		invoke print_F,offset MIDF,MID_COUNT
		invoke winTimer,1
		jmp input2_again
	input2_again:
		invoke printf,offset lpFmt_S1,offset NEXT
		invoke scanf,offset lpFmt_S2,offset CHOICE
		mov esi,offset CHOICE
		mov dl,[esi]
		cmp dl,CHOICE1
		jz function2
		cmp dl,CHOICE2
		jz exit
	cal_f proc
		mov ecx,SDA
		imul ecx,5
		add ecx,SDB
		mov eax,SDC
		sub ecx,eax
		add ecx,100
		sar ecx,7
		ret
		cal_f endp
	
	judge proc
	    call cal_f
		cmp ecx,100
		jg greater
		cmp ecx,100
		jl litter
		cmp ecx,100
		jz equal
	equal:
		invoke copy_data,offset MIDF,MID_COUNT
		inc MID_COUNT
		jmp back
	greater:
		invoke copy_data,offset HIGHF,HIGH_COUNT
		inc HIGH_COUNT
		jmp back
	litter:
		invoke copy_data,offset LOWF,LOW_COUNT
		inc LOW_COUNT
		jmp back
	back:
		ret
	judge endp
	
 exit:
	invoke ExitProcess,0
 main endp
 end
