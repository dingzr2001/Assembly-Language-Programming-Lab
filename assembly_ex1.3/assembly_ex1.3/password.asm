.686     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
 printf          PROTO C :VARARG
 scanf          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

.DATA
	lpFmt	db	"%s",0ah, 0dh, 0
	OUT_HINT DB 0DH,0AH,'Please Input Password:$',0
	OUT_WRONG DB 0DH,0AH,'wrong Password!$',0
	OUT_RIGHT DB 0DH,0AH,'Welcome!$',0
	format DB "%s",0
	input DB 11 DUP(0)
	password DB	'12345678',0
.STACK 200
.CODE
main proc c
   
   
   invoke printf,offset lpFmt,OFFSET OUT_HINT
   invoke scanf,offset format, offset input
   ;invoke printf,offset lpFmt, offset input
   MOV  ESI,offset input
   MOV  EDI,OFFSET password
   MOV  ECX,0
L1:
   CMP  ECX, 8
   JZ L3
   MOV  AH, [ESI]   ;�����������12���ֽڣ�����ÿ�δ���4���ֽ���
   MOV  BH, [EDI]
   CMP AH,BH
   JNZ  L2

   ADD  ESI, 1
   ADD  EDI, 1
   ADD  ECX, 1
   
   JMP L1
L2:
	invoke printf,offset lpFmt,OFFSET OUT_WRONG
   invoke ExitProcess, 0
L3:
	invoke printf,offset lpFmt,OFFSET OUT_RIGHT
	invoke ExitProcess, 0
main endp
END