.686     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

.DATA
lpFmt	db	"%s",0ah, 0dh, 0
  X   DB  10, 255, -1
  Y   DW  10, 255, -1
  Z   DD  10, 255, -1
  U   DW  ($-Z)/4
  STR1 DB  'Good', 0
  P   DD  X,  Y
  Q   DB   2 DUP (5, 6)
  buf1   db  '00123456789',0
  buf2   db  12 dup(0)   ; 12个字节的空间，初值均为 0 
.STACK 200
.CODE
main proc c
   MOV ECX, 0
L1:    
   MOV AH, BUF1[ECX]
   MOV BUF2[ECX], AH
   ADD ECX, 1
   CMP ECX, 12
   JNZ  L1

   invoke printf,offset lpFmt,OFFSET buf1
   invoke printf,offset lpFmt,OFFSET buf2
   invoke ExitProcess, 0
main endp
END
