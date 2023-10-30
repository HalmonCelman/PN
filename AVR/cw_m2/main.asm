;
; by KK
;

.macro LOAD_CONST
ldi @0, high(@2)
ldi @1,  low(@2)
.endmacro

LOAD_CONST R17,R16,0x0007

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