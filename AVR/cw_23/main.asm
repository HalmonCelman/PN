;
; by KK
;

ldi R22,5

rcall DelayInMs

DelayInMs:
	rcall DelayOneMs
	dec R22
	brbc 1,DelayInMs
	ret

DelayOneMs:
	ldi R25, 6
	ldi R24, 61
	CombinedLoop:
		sbiw R25:R24,1
		nop
		brcc CombinedLoop
	nop
	nop
	ret

; DelayOneMs - accurate - 8000 cycles with rcall
; DelayInMs - inaccuracy up to 9 cycles/8000 cycles -  0,01125 %