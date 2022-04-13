.686P
.MODEL FLAT,c
 extern ID:byte
.DATA
 
.CODE
cal_f proc SDA:dword,SDB:dword,SDC:dword,buf:dword
		mov eax,SDA
		mov SDA,eax
		mov eax,SDB
		mov SDB,eax
		mov eax,SDC
		mov SDC,eax
		mov ecx,SDA
		imul ecx,5
		add ecx,SDB
		mov eax,SDC
		sub ecx,eax
		add ecx,100
		sar ecx,7
		mov ebx,buf
		mov [ebx],ecx
		ret
	cal_f endp
	end