;
; by KK
;

ldi R20, 2 // 2 * 250 = 500

UpperLoop:
	ldi R21, 250
	LowerLoop:
		nop
		dec R21
		brbc 1, LowerLoop
	dec R20
	brbc 1, UpperLoop