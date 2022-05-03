.686P
.MODEL FLAT,STDCALL
printf   PROTO C:ptr sbtye, :VARARG
extern lpFmt_S1:byte,lpFmt_S2:byte,lpFmt2:byte
 source struct
	SAMID DB 9 DUP(0)   ;每组数据的流水号（可以从1开始编号）
	SDA   DD ?      ;状态信息a
	SDB   DD ?      ;状态信息b
	SDC   DD ?      ;状态信息c
	SDF   DD ?      ;处理结果f
source ends
.DATA
 OUTPUT_F db 'The data in MIDF are as followed:',0
 SEPARATOR db '-------------------',0
 SAMID_S db 'SAMID:',0
 SDA_S db 'SDA:',0
 SDB_S db 'SDB:',0
 SDC_S db 'SDC:',0
 SDF_S db 'SDF:',0
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