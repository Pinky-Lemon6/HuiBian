.686P
.MODEL FLAT,c
;extern SDA:dword,SDB:dword,SDC:dword,SAMID:byte

source struct
	SDA DD ?
	SDB DD ?
	SDC DD ?
	SDF DD ?
source ends
.CODE
copy_data proc buf:dword,n:dword,SDA:dword,SDB:dword,SDC:dword,SDF:dword
	mov edi,buf
	mov eax,0
	imul eax,n,TYPE source
	add edi,eax
	;mov dl,SAMID
	;mov [edi].source.SAMID,dl
	mov EAX,SDA
	mov [edi].source.SDA,EAX
	mov EAX,SDB
	mov [edi].source.SDB,EAX
	mov EAX,SDC
	mov [edi].source.SDC,EAX
	mov EAX,SDF
	mov [edi].source.SDF,EAX
	ret
	copy_data endp

	end