.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 ;copy_data PROTO:dword,:dword
 print_F PROTO C,MIDF:dword,MID_COUNT:dword
 f1 PROTO C,SAVED_USERNAME:ptr sbtye,SAVED_PWD:ptr sbyte
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 ;include winTimer.asm
 public SDA,SDB,SDC,SAMID
 public lpFmt_S1,lpFmt_S2,lpFmt2,OUTPUT_F
 public SAMID_S,SDA_S,SDB_S,SDC_S,SEPARATOR
 public SAVED_USERNAME,SAVED_PWD
 public function2
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
 WELCOME2 db 'Please input your data:',0
 MENU1 db 'Please input your user name:(No more than 10 characters)',0
 MENU2	db 'Please input your password:(No more than 10 characters)',0
 SUCCESS db 'OK!Welcome you:',0
 ERROR db 'Incorrect User name / Password!',0
 ATTEMPT db 'The number of attempts you have left is:',0
 NEXT db 'Please press "R" to input again or press "Q" to exit:',0
 OUTPUT_F db 'The data in MIDF are as followed:',0
 SEPARATOR db '-------------------',0
 SAMID_S db 'SAMID:',0
 SDA_S db 'SDA:',0
 SDB_S db 'SDB:',0
 SDC_S db 'SDC:',0
 THANK db 'Thanks for your use!',0
 SAMID db 9 DUP(0)  ;当前数据编号
 SDA   DD ?      ;状态信息a
 SDB   DD ?      ;状态信息b
 SDC   DD ?      ;状态信息c
 JUDGE1 dd 0
 ATT_N db 0
 DATA_N DD 10
 LOW_COUNT DD 0
 MID_COUNT DD 0
 HIGH_COUNT DD 0
 LOWF source 10000 DUP(<>)
 MIDF source 10000 DUP(<>)
 HIGHF source 10000 DUP(<>)
 CHOICE1 db 'R',0
 CHOICE2 db 'Q',0
 CHOICE db 0

 .STACK 200
 .CODE
 main proc c
	invoke f1,offset SAVED_USERNAME,offset SAVED_PWD
	call function2
	jmp exit
 
function2 proc
	start_2:
		;invoke winTimer,0
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
		;invoke winTimer,1
		jmp input2_again
	input2_again:
		invoke printf,offset lpFmt_S1,offset NEXT
		invoke scanf,offset lpFmt_S2,offset CHOICE
		mov esi,offset CHOICE
		mov dl,[esi]
		cmp dl,CHOICE1
		jz start_2
		cmp dl,CHOICE2
		jz back_2
	back_2:
		ret
	function2 endp
		
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
	
judge proc
	call cal_f
	cmp ecx,100
	jg greater
	cmp ecx,100
	jl litter
	cmp ecx,100
	jz equal
 equal:
	;invoke copy_data,offset MIDF,MID_COUNT
	inc MID_COUNT
	jmp back
 greater:
	;invoke copy_data,offset HIGHF,HIGH_COUNT
	inc HIGH_COUNT
	jmp back
 litter:
	;invoke copy_data,offset LOWF,LOW_COUNT
	inc LOW_COUNT
	jmp back
 back:
	ret
judge endp
	
 exit:
	invoke ExitProcess,0
 main endp
 end
