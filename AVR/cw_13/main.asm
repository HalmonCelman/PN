;
; by KK
;

; c)
InfiniteLoop:
	ldi R20, 5
	Decerase:
		dec R20
		brbc 1,Decerase
	rjmp InfiniteLoop

; Cycles = R20 * 3

/*

d) Cycles = R20 * 5
InfiniteLoop:
	ldi R20, 10
	Decerase:
		nop
		nop
		dec R20
		brbc 1,Decerase
	rjmp InfiniteLoop

e) Cycles = R20 * 5 + 5
InfiniteLoop:
	ldi R20, 10
	nop
	nop
	nop
	nop
	nop
	Decerase:
		nop
		nop
		dec R20
		brbc 1,Decerase
	rjmp InfiniteLoop
*/