.686P 
.model flat, c
  ExitProcess proto stdcall :dword
  includelib  kernel32.lib
  printf      proto c :vararg
  includelib  libcmt.lib
  includelib  legacy_stdio_definitions.lib
.data
 lpFmt   db	"%d",0ah, 0dh, 0
.stack   200
.code
main proc  

   mov  al,01100101B     ;  (eax)=0�����ڴ���ۼӺ�
   mov  bl,10100011B     ;  (ebx)=1������ָʾ��ǰ�ļ���
   add  al,bl  ;  (eax) = (eax) + (ebx)

exit:
   invoke printf, offset lpFmt, al
   invoke ExitProcess, 0
main  endp
end
