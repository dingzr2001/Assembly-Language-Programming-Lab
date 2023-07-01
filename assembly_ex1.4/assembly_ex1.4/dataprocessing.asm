.686     
.model flat, stdcall
 ExitProcess PROTO STDCALL :DWORD
 includelib  kernel32.lib  ; ExitProcess 在 kernel32.lib中实现
 printf          PROTO C :VARARG
 scanf          PROTO C :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib

.DATA
SAMID  DB 9 DUP(0)   ;每组数据的流水号（可以从1开始编号）
SDA   DD  256809     ;状态信息a
SDB   DD  -1023      ;状态信息b
SDC   DD   1265      ;状态信息c
SF     DD   ?       ;处理结果f
;lpFmt	db 	"%d%d%d",0ah, 0dh, 0
;string	db 	"%s",0ah, 0dh, 0
;midhint	db 	"mid",0ah, 0dh, 0
;lowhint	db 	"low",0ah, 0dh, 0
;highhint	db 	"high",0ah, 0dh, 0
LOWF DD 1000 DUP(?)
MIDF DD 1000 DUP(?)
HIGHF DD 1000 DUP(?)

.STACK 200
.CODE

main proc c
	;invoke scanf, offset lpFmt, offset lpFmt, offset lpFmt, offset SDA, offset SDB,offset SDC
   MOV  EAX, SDA
   MOV EBX, SDB
   MOV ECX, SDC   
   MOV  ECX,0
   IMUL	EAX, 5
   ADD EAX, SDB
   SUB EAX, SDC
   ADD EAX, 100
   SAR EAX, 7
   MOV SF, EAX
   CMP EAX, 100
   JZ L1
   CMP EAX, 100
   JNS L2
   JMP L3
L1:
   MOV EAX, SDA
   MOV MIDF, EAX
   MOV EAX, SDB
   MOV MIDF+4, EAX
   MOV EAX, SDC
   MOV MIDF+8, EAX
   ;invoke printf,offset lpFmt,MIDF,MIDF+4,MIDF+8
   ;invoke printf,offset string,offset midhint
   invoke ExitProcess, 0
L2:
   MOV EAX, SDA
   MOV HIGHF, EAX
   MOV EAX, SDB
   MOV HIGHF+4, EAX
   MOV EAX, SDC
   MOV HIGHF+8, EAX
   ;invoke printf,offset lpFmt,HIGHF,HIGHF+4,HIGHF+8
   ;invoke printf,offset string,offset highhint
   invoke ExitProcess, 0
L3:
   MOV EAX, SDA
   MOV LOWF, EAX
   MOV EAX, SDB
   MOV LOWF+4, EAX
   MOV EAX, SDC
   MOV LOWF+8, EAX
   ;invoke printf,offset lpFmt,LOWF,LOWF+4,LOWF+8
   ;invoke printf,offset string,offset lowhint
   invoke ExitProcess, 0

main endp
call TIMER
TIMER	PROC
	PUSH  DX
	PUSH  CX
	PUSH  BX
	MOV   BX, AX
	MOV   AH, 2CH
	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	MOV   AL, DH
	MOV   AH, 0
	IMUL  AX,AX,1000
	MOV   DH, 0
	IMUL  DX,DX,10
	ADD   AX, DX
	CMP   BX, 0
	JNZ   _T1
	MOV   CS:_TS, AX
_T0:	POP   BX
	POP   CX
	POP   DX
	RET
_T1:	SUB   AX, CS:_TS
	JNC   _T2
	ADD   AX, 60000
_T2:	MOV   CX, 0
	MOV   BX, 10
_T3:	MOV   DX, 0
	DIV   BX
	PUSH  DX
	INC   CX
	CMP   AX, 0
	JNZ   _T3
	MOV   BX, 0
_T4:	POP   AX
	ADD   AL, '0'
	MOV   CS:_TMSG[BX], AL
	INC   BX
	LOOP  _T4
	PUSH  DS
	MOV   CS:_TMSG[BX+0], 0AH
	MOV   CS:_TMSG[BX+1], 0DH
	MOV   CS:_TMSG[BX+2], '$'
	LEA   DX, _TS+2
	PUSH  CS
	POP   DS
	MOV   AH, 9
	INT   21H
	POP   DS
	JMP   _T0
_TS	DW    ?
 	DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
TIMER   ENDP
END

