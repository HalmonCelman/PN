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
	sts 0x60, R25
	sts 0x61, R24
	ldi R25, 6
	ldi R24, 59
	CombinedLoop:
		sbiw R25:R24,1
		nop
		brcc CombinedLoop
	lds R25,0x60
	lds R24,0x61
	nop
	nop
	nop
	nop
	ret

; dok³adnoœæ taka sama
; oba rejestry s¹ zapamiêtywane i przywracane
