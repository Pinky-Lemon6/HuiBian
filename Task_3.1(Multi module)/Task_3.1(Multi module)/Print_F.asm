;��д�ߣ���ʯ�� U202015351
;��������3��ģ����ɣ�1.main.asm 2.Print_F.asm 3.Copy_Data.asm
;��ģ��Ϊ������ʾģ�� Print_F.asm��������ʾ�洢���е�����
;��ģ����������ӳ���print_F
.686P
.MODEL FLAT,STDCALL
printf   PROTO C:ptr sbtye, :VARARG
extern SAMID_S:byte,SDA_S:byte,SDB_S:byte,SDC_S:byte,SDF_S:byte,SEPARATOR:byte
extern OUTPUT_F:byte,lpFmt_S1:byte,lpFmt_S2:byte,lpFmt2:byte
 source struct
	SAMID DB 9 DUP(0)   ;ÿ�����ݵ���ˮ�ţ����Դ�1��ʼ��ţ�
	SDA   DD ?      ;״̬��Ϣa
	SDB   DD ?      ;״̬��Ϣb
	SDC   DD ?      ;״̬��Ϣc
	SDF   DD ?      ;������f
source ends
.CODE
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
			invoke printf,offset lpFmt_S2,offset SDF_S
			invoke printf,offset lpFmt2,[edi].source.SDF
			add edi,TYPE source
			inc n
			jmp lopa
		print_exit:
			pop edi
			pop edx
			ret
		print_F endp
	end