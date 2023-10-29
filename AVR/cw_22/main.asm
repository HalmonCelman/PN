;
; by KK
;

ldi R22, 5

rcall DelayInMs

DelayInMs:
	ldi R25, 6
	ldi R24, 62
	CombinedLoop:
		sbiw R25:R24,1
		nop
		brcc CombinedLoop
	dec R22
	nop
	brbc 1,DelayInMs
	ret

	; inacurracy up to 7 cycles/8000 cycles = 0,0875% - the bigger value in R22 the bigger accuracy