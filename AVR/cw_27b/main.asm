;
; by KK
;

ldi R17,0
ldi R16,1

rcall DelayInMs

DelayInMs:
	push R17
	push R16
	InternalLoop:
		rcall DelayOneMs
		subi R16,1
		brbc 1,InternalLoop
		subi R17,1
		brcc InternalLoop
	pop R16
	pop R17
	ret

DelayOneMs:
	push R25
	push R24
	ldi R25, 6
	ldi R24, 59
	CombinedLoop:
		sbiw R25:R24, 1
		nop
		brcc CombinedLoop
	pop R24
	pop R25
	nop
	nop
	nop
	nop
	ret

; inaccuracy - up to 21 cycles / 8000 cycles =  0,2375 %