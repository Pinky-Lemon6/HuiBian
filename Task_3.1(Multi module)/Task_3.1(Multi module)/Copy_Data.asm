.686P
.MODEL FLAT,STDCALL
extern SDA:dword,SDB:dword,SDC:dword,SAMID:byte
 source struct
	SAMID DB 9 DUP(0)   ;ÿ�����ݵ���ˮ�ţ����Դ�1��ʼ��ţ�
	SDA   DD ?      ;״̬��Ϣa
	SDB   DD ?      ;״̬��Ϣb
	SDC   DD ?      ;״̬��Ϣc
	SDF   DD ?      ;������f
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