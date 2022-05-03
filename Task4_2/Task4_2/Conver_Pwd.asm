.686P
.MODEL FLAT,STDCALL

.DATA
METHOR DB '3157906397',0
LEN DD 10
.CODE
Conver PROC PWD:dword,PWD1:dword
	push edi
	push eax
	push esi
	mov edi,PWD
	mov esi,offset METHOR
	mov eax,PWD1
 lopa:
	cmp LEN,0
	jz exit
	mov dl,[edi]
	XOR dl,[esi]
	mov [eax],dl
	inc edi
	inc esi
	inc eax
	dec LEN
	jmp lopa
 exit:
	pop edi
	pop eax
	pop esi
	ret
	conver endp
	end
