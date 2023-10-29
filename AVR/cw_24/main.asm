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
	ldi R25, 6
	ldi R24, 61
	CombinedLoop:
		sbiw R25:R24,1
		nop
		brcc CombinedLoop
	nop
	nop
	ret

; R24 jest nadpisywane w DelayOneMs co powoduje nieskoñczon¹ pêtlê