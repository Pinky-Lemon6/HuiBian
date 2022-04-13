;编写者：李石峪 U202015351
;本程序由3个模块组成：1.main.asm 2.Print_F.asm 3.Copy_Data.asm
;本模块为数据显示模块 Print_F.asm，用于显示存储区中的数据
;本模块包含以下子程序：print_F
.686P
.MODEL FLAT,STDCALL
printf   PROTO C:ptr sbtye, :VARARG
extern SAMID_S:byte,SDA_S:byte,SDB_S:byte,SDC_S:byte,SDF_S:byte,SEPARATOR:byte
extern OUTPUT_F:byte,lpFmt_S1:byte,lpFmt_S2:byte,lpFmt2:byte
 source struct
	SAMID DB 9 DUP(0)   ;每组数据的流水号（可以从1开始编号）
	SDA   DD ?      ;状态信息a
	SDB   DD ?      ;状态信息b
	SDC   DD ?      ;状态信息c
	SDF   DD ?      ;处理结果f
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