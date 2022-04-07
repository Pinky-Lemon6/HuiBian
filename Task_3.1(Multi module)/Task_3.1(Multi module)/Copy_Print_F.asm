.686P
.MODEL FLAT,STDCALL
printf   PROTO C:ptr sbtye, :VARARG
extern SDA:dword,SDB:dword,SDC:dword,SAMID:byte
extern SAMID_S:byte,SDA_S:byte,SDB_S:byte,SDC_S:byte,SEPARATOR:byte
extern OUTPUT_F:byte,lpFmt_S1:byte,lpFmt_S2:byte,lpFmt2:byte
 source struct
	SAMID DB 9 DUP(0)   ;每组数据的流水号（可以从1开始编号）
	SDA   DD ?      ;状态信息a
	SDB   DD ?      ;状态信息b
	SDC   DD ?      ;状态信息c
	SDF   DD ?      ;处理结果f
source ends
.CODE
copy_data proc buf:dword,n:dword
	mov edi,buf
	mov eax,0
	imul eax,n,TYPE source
	add edi,eax
	mov dl,SAMID
	mov [edi].source.SAMID,dl
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

 print_F proc buf:dword,d_n:dword
		local n:dword
		push edi
		push edx
		mov edi,buf
		mov n,0
		invoke printf,offset lpFmt_S1,offset OUTPUT_F
		lopa:
		    mov edx,n
			cmp edx,d_n
			jz print_exit
			;mov eax,0
			;imul eax,n,TYPE source
			invoke printf,offset lpFmt_S1,offset SEPARATOR
			invoke printf,offset lpFmt_S2,offset SAMID_S
			invoke printf,offset lpFmt2,[edi].source.SAMID
			invoke printf,offset lpFmt_S2,offset SDA_S
			invoke printf,offset lpFmt2,[edi].source.SDA
			invoke printf,offset lpFmt_S2,offset SDB_S
			invoke printf,offset lpFmt2,[edi].source.SDB
			invoke printf,offset lpFmt_S2,offset SDC_S
			invoke printf,offset lpFmt2,[edi].source.SDC
			;invoke printf,offset lpFmt2,[edi].source.SDF
			add edi,TYPE source
			inc n
			jmp lopa
		print_exit:
			pop edi
			pop edx
			ret
		print_F endp
	end