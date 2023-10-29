;
; by KK
;

ldi R22, 4
DelayLoop:
	ldi R25, 6
	ldi R24, 62
	CombinedLoop:
		sbiw R25:R24,1
		nop
		brcc CombinedLoop
	dec R22
	nop
	brbc 1,DelayLoop

; R25 <=> x, R24 <=> y, R22 <=> z
; Cycles = z(256*5*x+5*(y+1)+5)
; only matching solution: x=6 y=62
