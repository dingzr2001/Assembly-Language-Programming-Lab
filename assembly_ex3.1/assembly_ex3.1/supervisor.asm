.686p
.model flat, c
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess �� kernel32.lib��ʵ��
 printf          PROTO C :VARARG
 scanf          PROTO C :VARARG
 clock proto
 STOREDATA PROTO, SAMPLEADD: DWORD
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
 EXTERN CALF:NEAR

SAMPLES  STRUCT
	SAMID  DB 9 DUP('0')   ;ÿ�����ݵ���ˮ��
	SDA   DD  2540     ;״̬��Ϣa
	SDB   DD  0      ;״̬��Ϣb
	SDC   DD   0      ;״̬��Ϣc
	SF    DD   0        ;������f
SAMPLES  ENDS

.DATA
lpFmt	db	"%s",0ah, 0dh, 0
chFmt	db	"%c", 0
intFmt	db	"%d",0ah, 0dh, 0
LineBreak DB 0ah, 0dh, 0
TMPC DB 0, 0
MIDCNT DD 0
USERNAME_HINT DB 'Please Input Username:',0DH,0AH,0
PASSWORD_HINT DB 'Please Input Password:',0DH,0AH,0
OUT_WRONG DB 'wrong username or password!',0DH,0AH,0
OUT_RIGHT DB 'Welcome!',0DH,0AH,0
NEXT_HINT DB 'Next: PRESS Q to quit, R to re-run',0DH, 0AH, 0  
WRONG_INPUT_HINT DB "Wrong input! Press Enter to retry!", 0AH, 0DH, 0
format DB "%s",0
USERNAMEIN DB 12 DUP(0)
PASSWORDIN DB 12 DUP(0)
USERNAME DB 'dingzhaorui',0
password DB	'0123456789',0
sample1 SAMPLES <'000000001',2540,0,0,0>
sample2 SAMPLES <'000000002',1980,2,4,0>
sample3 SAMPLES <'000000003',2022,2045,2062,0>
string	db 	"%s",0ah, 0dh, 0
LOWF DB 100000 DUP(?)
MIDF DB 100000 DUP(?)
HIGHF DB 100000 DUP(?)
LOWPTR DD OFFSET LOWF
MIDPTR DD OFFSET MIDF
HIGHPTR DD OFFSET HIGHF
timecurrent DD 0
timecnt DD 0
nextstep DB 0

.STACK 200
.CODE
verifyPassword MACRO ADDUSERNAME, ADDPASSWORD
	LOCAL CMP1, CORRECT, WRONG, ENDJMP
	PUSH EAX
	PUSH EBX
	PUSH ECX
	MOV ESI, ADDUSERNAME
	MOV EDI, OFFSET USERNAME
	CMPUSERNAME:
		MOV AL, [ESI]
		MOV BL, [EDI]
		CMP BL, 0
		JZ USERNAMECORRECT
		CMP AL, BL
		JNZ WRONG
		INC ESI
		INC EDI
		JMP CMPUSERNAME
	USERNAMECORRECT:
		CMP AL, 0
		JNZ WRONG
		MOV ESI, ADDPASSWORD
		MOV EDI, OFFSET PASSWORD
		JMP CMPPASSWORD
	CMPPASSWORD:
		MOV AL, [ESI]
		MOV BL, [EDI]
		CMP BL, 0
		JZ PASSWORDCORRECT
		CMP AL, BL
		JNZ WRONG
		INC ESI
		INC EDI
		JMP CMPPASSWORD
	PASSWORDCORRECT:
		CMP AL, 0
		JNZ WRONG
		invoke printf,offset lpFmt,OFFSET OUT_RIGHT
		MOV EDX, 1
		JMP ENDJMP
	WRONG:
		invoke printf,offset lpFmt,OFFSET OUT_WRONG
		JMP ENDJMP
	ENDJMP:
		POP ECX
		POP EBX
		POP EAX
ENDM

main proc c

invoke clock
mov timecurrent, eax
MOV ECX, 0
VERIFY:
	PUSH ECX
	invoke printf,offset lpFmt,OFFSET USERNAME_HINT
	invoke scanf,offset format, offset USERNAMEIN
	invoke printf,offset lpFmt,OFFSET PASSWORD_HINT
	invoke scanf,offset format, offset PASSWORDIN
	
	MOV EDX, 0 
	VERIFYPASSWORD OFFSET USERNAMEIN, OFFSET PASSWORDIN
	CMP EDX, 1
	JZ NEXTPREP
	POP ECX
	INC ECX
	CMP ECX, 3
	JNZ VERIFY
	JZ EXIT

NEXTPREP:
	MOV ECX, 0
	JMP NEXT

NEXT:
	MOV EAX, SAMPLE1.SDA
	MOV EBX, SAMPLE1.SDB
	MOV EDX, SAMPLE1.SDC
   CALL CALF 
   MOV SAMPLE1.SF, EAX
   invoke STOREDATA, OFFSET SAMPLE1

	ADD ECX, 1
	CMP ECX, 5
	JNZ NEXT
	MOV ECX, MIDCNT

L5:
	
	MOV ESI, OFFSET MIDF
	CALL SHOWMIDF
	LOOP L5

L6:
	invoke printf, offset lpFmt, OFFSET NEXT_HINT
	invoke scanf, offset chFmt, OFFSET tmpc
	invoke scanf, offset chFmt, OFFSET NEXTSTEP
	MOV AL, NEXTSTEP
	CMP AL, 'r'
	JZ NEXTPREP
	CMP AL, 'q'
	JZ EXIT
	JNZ WRONGINPUT

WRONGINPUT:
	invoke printf, OFFSET LPFMT, OFFSET WRONG_INPUT_HINT
	JMP L6
EXIT:
	invoke clock
	;sub eax, timecurrent
	;mov timecnt, eax
	;invoke printf, offset lpFmt, timecnt
	;invoke printf,offset lpFmt,ECX
	invoke ExitProcess, 0
main endp



;--------------------------�����ݴ�������---------------------------
STOREDATA PROC, SAMPLEADD: DWORD
MOV EDX, 0
MOV ESI, SAMPLEADD
MOV EAX, [ESI+21]
CMP EAX, 100
   JZ L1
   JNS L2
   JMP L3

L1:
	MOV EDI, MIDPTR ;����MIDPTR��ֵ����MIDF����ǰ��ַ
	STORECHARMID:   
	   MOV AL, [ESI]
	   MOV BYTE PTR[EDI], AL
	   INC ESI
	   INC EDI
	   INC EDX
	   CMP EDX,9
	   JNZ STORECHARMID
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	INC MIDCNT
	MOV MIDPTR, EDI
	JMP L4
L2:
    MOV EDI, HIGHPTR ;����MIDPTR��ֵ����MIDF����ǰ��ַ
	STORECHARHIGH:   
	   MOV AL, [ESI]
	   MOV BYTE PTR[EDI], AL
	   INC ESI
	   INC EDI
	   INC EDX
	   CMP EDX,9
	   JNZ STORECHARHIGH
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV HIGHPTR, EDI
	JMP L4
L3:
    MOV EDI, LOWPTR ;����MIDPTR��ֵ����MIDF����ǰ��ַ
	STORECHARLOW:   
	   MOV AL, [ESI]
	   MOV BYTE PTR[EDI], AL
	   INC ESI
	   INC EDI
	   INC EDX
	   CMP EDX,9
	   JNZ STORECHARLOW
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	MOV EAX, [ESI]
	MOV DWORD PTR[EDI], EAX
	ADD ESI, 4
	ADD EDI, 4
	INC MIDCNT
	MOV LOWPTR, EDI
	JMP L4
L4:
	RET
STOREDATA ENDP

;-------------------��ʾMIDF��������-----------------
SHOWMIDF PROC
	LOCAL TMP:BYTE
	PUSH ECX
	MOV ECX, 9
	SHOWSAMPLE:
		PUSH ECX
		MOV AL, BYTE PTR [ESI]
		MOV TMP, AL
		invoke printf, offset CHFMT, TMP
		POP ECX
		INC ESI
		LOOP SHOWSAMPLE
	invoke printf, offset LineBreak
	invoke printf, offset intFmt, DWORD PTR [ESI]
	ADD ESI, 4
	invoke printf, offset intFmt, DWORD PTR [ESI]
	ADD ESI, 4
	invoke printf, offset intFmt, DWORD PTR [ESI]
	ADD ESI, 4
	invoke printf, offset intFmt, DWORD PTR [ESI]
	ADD ESI, 4
	POP ECX
	RET
SHOWMIDF ENDP
END