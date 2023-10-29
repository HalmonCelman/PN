;
; by KK
;

ldi R24,5

rcall DelayInMs

DelayInMs:
	rcall DelayOneMs
	dec R24
	brbc 1,DelayInMs
	ret

DelayOneMs:
	sts 0x60, R24
	ldi R25, 6
	ldi R24, 60
	CombinedLoop:
		sbiw R25:R24,1
		nop
		brcc CombinedLoop
	lds R24,0x60
	nop
	nop
	nop
	ret

; accuracy same as in cw_23
; value of R24 is stored in 0x60 before overwriting, and returned before returning from subprogram
