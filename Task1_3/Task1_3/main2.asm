.686P
.MODEL FLAT,STDCALL
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf   PROTO C:ptr sbtye, :VARARG
 scanf    PROTO C:ptr sbyte, :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 .DATA
 lpFmt	dw '%s',0ah,0dh,0
 lpFmt1	dw '%s',0
 IN_PWD	dw 10 dup(0),0
 MENU	db 'Please input your password:',0
 SUCCESS	db 'OK!',0
 ERROR	db 'Incorrect Password！',0
 SAVED_PWD	db 'U202015351',0
 .STACK 200
 .CODE
 main proc c
 invoke printf,offset lpFmt,offset MENU
 invoke scanf,offset lpFmt1,offset IN_PWD
 push offset SAVED_PWD
 push offset IN_PWD
 call strcmp
 add esp,16
 cmp eax,0
 je L1
 invoke printf,offset lpFmt,offset ERROR
 jmp exit
 L1:
 invoke printf,offset lpFmt,offset SUCCESS
 jmp exit
 exit:
 invoke ExitProcess,0
 main endp
strcmp proc
   push ebp
	mov ebp,esp
	push esi
	push edi
	push edx
	mov edi,[ebp+16]
	mov esi,[ebp+24]
 strcmp_start:
    mov dx,[edi]
	cmp dx,[esi]
	ja strcmp_large
	jb strcmp_little
	cmp dx,0
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
    pop edx
	pop edi
	pop esi
	pop ebp
	ret
 strcmp endp

 end