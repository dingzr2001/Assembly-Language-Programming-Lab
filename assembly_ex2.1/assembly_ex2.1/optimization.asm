.686p
.model flat, c
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 scanf          PROTO C :VARARG
 clock proto
 STOREDATA PROTO, SAMPLEADD: DWORD
 CALF PROTO
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

SAMPLES  STRUCT
	SAMID  DB 9 DUP('0')   ;每组数据的流水号
	SDA   DD  2540     ;状态信息a
	SDB   DD  0      ;状态信息b
	SDC   DD   0      ;状态信息c
	SF    DD   0        ;处理结果f
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
USERNAMEIN DB 11 DUP(0)
PASSWORDIN DB 11 DUP(0)
USERNAME DB 'dingzhaorui',0
password DB	'dzr',0
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

main proc c

invoke clock
mov timecurrent, eax
MOV ECX, 0

NEXTPREP:
	MOV ECX, 0
	JMP NEXT

NEXT:
	MOV EAX, SAMPLE1.SDA  
   IMUL EAX, 5
    ADD EAX, SAMPLE1.SDB
    SUB EAX, SAMPLE1.SDC
    ADD EAX, 100
	SAR EAX, 7
   MOV SAMPLE1.SF, EAX
MOV EDX, 0
LEA ESI, SAMPLE1
MOV EAX, [ESI+21]
CMP EAX, 100
   JZ L1
   JNS L2
   JMP L3

L1:
	MOV EDI, MIDPTR ;存入MIDPTR的值，即MIDF区当前地址
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
	MOV EAX, MIDCNT
	CMP EAX, 4000
	JZ L5
	JNZ L4
L2:
    MOV EDI, HIGHPTR ;存入MIDPTR的值，即MIDF区当前地址
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
    MOV EDI, LOWPTR ;存入MIDPTR的值，即MIDF区当前地址
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

L5:
	MOV MIDCNT, 0
	LEA EAX, MIDF
	MOV MIDPTR, EAX
L4:
	ADD ECX, 1
	CMP ECX, 100000000
	JNZ NEXT
	MOV ECX, MIDCNT

EXIT:
	invoke clock
	sub eax, timecurrent
	mov timecnt, eax
	invoke printf, offset intFmt, timecnt
	;invoke printf,offset intFmt,ECX
	invoke ExitProcess, 0
main endp
END