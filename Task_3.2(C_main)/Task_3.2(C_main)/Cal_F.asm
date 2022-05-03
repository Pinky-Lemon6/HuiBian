;编写者：李石峪 U202015351
;本程序由3个模块组成：1.main.c 2.Cal_F.asm 3.Copy_Data.asm
;本模块为数据复制模块 Cal_F.asm，用于计算一组输入的数据的f值
;本模块包含以下子程序：cal_f

.686P
.MODEL FLAT,c
 extern ID:byte
.DATA
 
.CODE
cal_f proc SDA:dword,SDB:dword,SDC:dword,buf:dword
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