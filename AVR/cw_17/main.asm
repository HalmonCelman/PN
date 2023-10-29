;
; by KK
;

ldi R22, 4

DelayLoop:
	ldi R20, 20
	UpperLoop:
		ldi R21, 132
		LowerLoop:
			dec R21
			brbc 1, LowerLoop
		nop
		dec R20
		brbc 1, UpperLoop
	dec R22
	brbc 1, DelayLoop

; inacurracy 3 cycles/8000 cycles = 0,0375%