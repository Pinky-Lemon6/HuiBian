.686P
.MODEL FLAT,STDCALL
extern SDA:dword,SDB:dword,SDC:dword,SAMID:byte
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

	end