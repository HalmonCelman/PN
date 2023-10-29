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
	push R25
	push R24
	ldi R25, 6
	ldi R24, 59
	CombinedLoop:
		sbiw R25:R24,1
		nop
		brcc CombinedLoop
	pop R24
	pop R25
	nop
	nop
	nop
	nop
	ret

; dok³adnoœæ taka sama
; oba rejestry s¹ zapamiêtywane i przywracane tym razem na stosie
