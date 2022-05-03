;编写者：李石峪 U202015351
;本程序由3个模块组成：1.main.c 2.Cal_F.asm 3.Copy_Data.asm
;本模块为数据复制模块 Copy_Data.asm，用于将数据复制到指定存储区
;本模块包含以下子程序：copy_data
.686P
.MODEL FLAT,c

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