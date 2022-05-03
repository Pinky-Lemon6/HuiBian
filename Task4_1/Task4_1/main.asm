.386
STACK	SEGMENT USE16	STACK
		DB 400 DUP(0)
STACK 	ENDS

CODE 	SEGMENT USE16
		ASSUME CS:CODE,DS:CODE, SS:STACK
	 
STATUS 	DB 	0
COUNT 	DB 	18
HOUR	DB	?, ?, ':'
MIN 	DB 	?, ?, ':'
SEC 	DB 	?, ?
BUF_LEN	 = $ - STATUS
CURSOR	DW	?
FLAG 	DB 	0 
OLD_INT DW 	?, ?
SELECT_ITEM  BYTE 	?
PROMPT  DB  'Please Select:   1: Simple Display Chars.',0
MESSAGE DB  'Press any key to return.',0

;新的INT 08H的代码
NEW08H	PROC	FAR
		PUSHF
		CALL	DWORD	PTR	CS:OLD_INT
		DEC		CS:COUNT
		JZ		DISP
		IRET
DISP:	MOV		CS:COUNT,18
		STI
		PUSHA
		PUSH	DS
		PUSH	ES
		MOV		AX,CS
		MOV		DS,AX
		MOV		ES,AX
		CALL	GET_TIME
		MOV		BH,0
		MOV		AH,3
		INT		10H
		MOV		CURSOR,DX
		MOV		BP,OFFSET	HOUR
		MOV		BH,0
		MOV		DH,0
		MOV		DL,79-BUF_LEN
		MOV		BL,07H
		MOV		CX,BUF_LEN
		MOV		AL,0
		MOV		AH,13H
		INT		10H
		MOV		BH,0
		MOV		DX,CURSOR
		MOV		AH,2
		INT		10H

		POP		ES
		POP		DS
		POPA
		IRET
NEW08H	ENDP

GET_TIME PROC	
		 MOV	AL,4
		 OUT	70H,AL
		 JMP	$+2
		 IN		AL,71H
		 MOV	AH,AL
		 AND	AL,0FH
		 SHR	AH,4
		 ADD	AX,3030H
		 XCHG	AH,AL
		 MOV	WORD PTR HOUR,AX

		 MOV	AL,2
		 OUT	70H,AL
		 JMP	$+2
		 IN		AL,71H
		 MOV	AH,AL
		 AND	AL,0FH
		 SHR	AH,4
		 ADD	AX,3030H
		 XCHG	AH,AL
		 MOV	WORD PTR MIN,AX
		 MOV	AL,0
		 OUT	70H,AL
		 JMP	$+2
		 IN		AL,71H
		 MOV	AH,AL
		 AND	AL,0FH
		 SHR	AH,4
		 ADD	AX,3030H
		 XCHG	AH,AL
		 MOV	WORD PTR SEC,AX
		 RET
GET_TIME ENDP


; 获取及设置8号中断的处理程序入口地址

GET_SET_INTR8_ADDRESS  PROC
         ; 获取原 8 号中断的中断处理程序的入口地址
        MOV   AX, 3508H
        INT   21H
        MOV   OLD_INT,  BX
        MOV   OLD_INT+2, ES

           ; 设置新的 8号中断的中断处理程序的入口地址
        MOV   DX, OFFSET NEW08H
        MOV   AX, 2508H
        INT   21H
        RET
GET_SET_INTR8_ADDRESS  ENDP



RESTORE_INTR8_RETURN    PROC
;        原来的程序是将中断处理程序的入口地址复原
         LDS    DX, DWORD PTR OLD_INT
         MOV   AX, 2508H
         INT    21H
         MOV   AH, 4CH
         INT    21H

RESTORE_INTR8_RETURN  ENDP 


RESIDULE_INTR8      PROC
    ;       将新的中断处理程序驻留内存
        MOV   DX, OFFSET DELAY+15
        MOV   CL, 4
        SHR   DX, CL
        ADD   DX, 10H
        ADD   DX, 70H
        MOV   AL, 0
        MOV   AH, 31H
        INT   21H
RESIDULE_INTR8   ENDP

DELAY   proc
          push dx
          push ax
          mov dx, 10H
          mov ax, 0
        s1:  sub ax, 1                                     ;-1的反码是65535
          sbb dx, 0                                     ;此时CF寄存器是1，则dx-1
          cmp ax, 0                                     ;内循环
          jne s1
          cmp dx, 0                                     ;外循环
          jne s1
          pop ax
          pop dx
          ret
DELAY endp
; -------------------------------------------------------------------------------------------------------
; 主程序开始
; 程序从此处开始执行

BEGIN:   
          ; 显示定义在代码段中的 MESSAGE串中的内容，

        PUSH  CS
        POP   DS

        LEA   DX, PROMPT  ; 显示提示串 PROMPT
        MOV   AH, 9
        INT   21H  
        
        MOV  AH, 1    ; 输入选择
        INT   21H

        MOV  SELECT_ITEM, AL

        LEA   DX, MESSAGE    ; 显示提示串 MESSAGE
        MOV   AH, 9  
        INT   21H  
          
         CMP    SELECT_ITEM,  '1'
         JZ       DISP_CHARS
                                                               ; --------------------------------
         CALL   GET_SET_INTR8_ADDRESS      ;   设置新的中断向量
                                                               ; --------------------------------       

DISP_CHARS:
        MOV   DL,30H
LOOP_DISP:    
        MOV   AH, 2           ;   显示一个字符
        INT    21H
    
        CALL  DELAY           ;  希望该程序在运行过程中，能看到 8号中断产生后的运行效果
                                     ;   因而，缓慢（即代有延时功能）的显示一些字符。          

         MOV   AH, 0BH       ;   判断有无击键，无则继续。有按键中止         
         INT   21H
         CMP   AL, 0   
         JNZ    EXIT

        INC    DL                ;  准备下一个要显示的字符
        CMP   DL, 200
        JNZ   CONTINUE
        MOV   DL, 30H

CONTINUE:
        JMP    LOOP_DISP
EXIT:
       CMP  SELECT_ITEM, '1'
       JZ    EXIT1
       CMP  SELECT_ITEM, '3'
       JZ     EXIT3
       JMP  EXIT2
EXIT1: 
       MOV  AH,4CH
       INT   21H
EXIT2:
                         ;    原来的程序是将中断处理程序的入口地址复原
                         ;    并返回 DOS
       CALL    RESTORE_INTR8_RETURN       
EXIT3:
                         ;       将新的中断处理程序驻留内存, 并返回 DOS
       CALL    RESIDULE_INTR8 
CODE    ENDS
        END  BEGIN
