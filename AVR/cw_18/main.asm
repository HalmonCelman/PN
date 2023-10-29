;
; by KK
;

ldi R22, 4
DelayLoop:
	ldi R20, 242
	ldi R21, 67
	ldi R19, 1	; for incrementing
	ldi R18, 0	; for adding with carry
	CombinedLoop:
		add R21, R19
		brcc CombinedLoop
		nop
		ldi R21, 67
		adc R20, R18
		brcc CombinedLoop
	dec R22
	brbc 1,DelayLoop
nop
; (256-R20) <=> x, (256-R21) <=> y, R22 <=> z
; Cycles = z(x(4+3*y)+6)
; only matching solution x=14, y = 189 => R20 = 242, R21 = 67