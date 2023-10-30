;
; by KK
;


Data: .db 0, 1, 4, 9, 16, 25, 36, 49, 64, 81

ldi R16, 9
rcall Convert
nop

; subprograms
Convert:
	ldi R30, low(Data<<1)
	ldi R31, high(Data<<1)
	
	Convert_Loop:
		adiw R31:R30,1
		subi R16,1
		brcc Convert_Loop
	sbiw R31:R30, 1

	lpm R16, Z
	ret