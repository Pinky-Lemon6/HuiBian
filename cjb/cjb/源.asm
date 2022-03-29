.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
; include winTimer.asm
 AREA struct 
	SDA  DD 0
	SDB  DD 0
	SDC  DD 0
	SF   DD 0 
 AREA ends
 .DATA
 BUF   DB  "%d",0ah,0
 BUFD  DB  "%d",0
 BUFS  DB  "%s",0ah,0
 LOWF  AREA 1050 DUP(<>)
 MIDF  AREA 1050 DUP(<>)
 HIGHF AREA 1050 DUP(<>)
 SDA   DD  256809     ;状态信息a
 SDB   DD  -1023      ;状态信息b
 SDC   DD   1265      ;状态信息c
 SF    DD   0         ;处理结果f
 NUM01 DD   0
 NUM02 DD   0
 NUM03 DD   0
 NUM1  DD   0
 NUM2  DD   0
 NUM3  DD   0
 BEGIN DD   0
 LOOPS DD   0
 CHANCE DD  3
 NAME DB "czt" ,0
 PASSWORD DB "1919810",0
 INNAME DB 10 dup(0),0
 INPASSWORD DB 10 dup(0),0
 PRINTNAME DB "Please input your username:",0
 PRINTPASS DB "Please input your password:",0
 PRINTERROR DB "Username or Password Error!",0
 ;PRINT1		DB "LOWF:",0
; PRINT2		DB "MIDF:",0
 ;PRINT3     DB "HIGHF:",0
 ;PRINT4     DB "-------",0
 .STACK 200
 .CODE
 main proc c
     stringcmp macro s1,s2,len
	    local compare
		push eax
		mov ebx,len
		compare:
		mov ecx,s1[len]
		mov s2[len],ecx
		jne error
		dec len
		cmp len,0
		jne compare
		pop eax
		endm
  scanf_S:
	 MOV EAX,2
	 MOV ECX,6
	 invoke printf,offset BUFS,offset PRINTNAME
	 invoke scanf ,offset BUFS ,offset INNAME
	 invoke printf,offset BUFS,offset PRINTPASS
	 invoke scanf ,offset BUFS ,offset INPASSWORD
	 stringcmp INNAME,INPASSWORD,EAX
	 stringcmp INNAME,INPASSWORD,ECX
     jmp in
  error:
	 invoke printf,offset BUFS,offset ERROR
	 dec CHANCE
	 cmp CHANCE,0
	 jz endmain
	 jmp scanf
  in:
     mov LOOPS,1000
	 mov ecx,0
	 invoke scanf ,offset BUFD ,offset SDA
	 invoke scanf ,offset BUFD ,offset SDB
	 invoke scanf ,offset BUFD ,offset SDC
;	 invoke winTimer ,0    ;输入第一组数据时计时开始
  start:
     cmp loops,1000
	 je inputjmp
	 invoke scanf ,offset BUFD ,offset SDA
	 invoke scanf ,offset BUFD ,offset SDB
	 invoke scanf ,offset BUFD ,offset SDC
  inputjmp:
	 mov eax,SDA
	 sal eax,2
	 add eax,SDA
	 add eax,SDB
	 sub eax,SDC
	 add eax,100
	 sar eax,7
	 mov SF,eax
	 cmp SF,100
	 jl little
	 cmp SF,100
	 jg great
	 cmp SF,100
	 je equal
	 jmp exit
 little:
	 MOV esi,offset LOWF
	 ADD ESI,NUM1
	 MOV ECX ,SDA
	 MOV [ESI].AREA.SDA,ECX
	 MOV ECX ,SDB
	 MOV [ESI].AREA.SDB,ECX
	 MOV ECX ,SDC
	 MOV [ESI].AREA.SDC,ECX
	 MOV ECX ,SF
	 MOV [ESI].AREA.SF,ECX
	 ADD NUM1,16
	 sub LOOPS,1
	 cmp LOOPS,0
	 je exit
	 jmp start
 great:
     mov esi,offset HIGHF
	 ADD ESI,NUM2
	 MOV ECX ,SDA
	 MOV [ESI].AREA.SDA,ECX
	 MOV ECX ,SDB
	 MOV [ESI].AREA.SDB,ECX
	 MOV ECX ,SDC
	 MOV [ESI].AREA.SDC,ECX
	 MOV ECX ,SF
	 MOV [ESI].AREA.SF,ECX
	 ADD NUM2,16
	 sub LOOPS,1
	 cmp LOOPS,0
	 je exit
	 jmp start
 equal:
	 mov esi,offset MIDF
	 ADD ESI,NUM3
	 MOV ECX ,SDA
	 MOV [ESI].AREA.SDA,ECX
	 MOV ECX ,SDB
	 MOV [ESI].AREA.SDB,ECX
	 MOV ECX ,SDC
	 MOV [ESI].AREA.SDC,ECX
	 MOV ECX ,SF
	 MOV [ESI].AREA.SF,ECX
	 ADD NUM3,16
	 sub LOOPS,1
	 cmp LOOPS,0
	 je exit
	 jmp start

 exit:
	;;输出开始
	;;输出结束
;	 invoke winTimer, 1
 endmain:
     invoke ExitProcess,0
main endp
 end