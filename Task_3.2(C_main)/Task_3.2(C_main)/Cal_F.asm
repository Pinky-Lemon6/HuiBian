;��д�ߣ���ʯ�� U202015351
;��������3��ģ����ɣ�1.main.c 2.Cal_F.asm 3.Copy_Data.asm
;��ģ��Ϊ���ݸ���ģ�� Cal_F.asm�����ڼ���һ����������ݵ�fֵ
;��ģ����������ӳ���cal_f

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