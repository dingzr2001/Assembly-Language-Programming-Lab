.686
	.model flat, c
	 printf          PROTO C :VARARG
 scanf          PROTO C :VARARG
	PUBLIC CALF
.CODE

;----------����F��ֵ---------------
CALF PROC
    IMUL EAX, 5
    ADD EAX, EBX
    SUB EAX, EDX
    ADD EAX, 100
    SAR EAX, 7
	RET
CALF ENDP

END