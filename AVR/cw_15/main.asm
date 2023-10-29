;
; by KK
;

ldi R20, 40

UpperLoop:
	ldi R21, 82
	LowerLoop:
		dec R21
		brbc 1, LowerLoop
	nop
	dec R20
	brbc 1, UpperLoop

; R20 - x, R21 -y
; x*(4 + y*3) =  10000
; solutions
; x=40 y=82
; x=100 y=32
; x=250 y-12