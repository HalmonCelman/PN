;
; by KK
;


Data: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

ldi R16, 9
rcall DigitTo7segCode
nop

; subprograms
DigitTo7segCode:
	push R30
	push R31

	ldi R30, low(Data<<1)
	ldi R31, high(Data<<1)
	
	Convert_Loop:
		adiw R31:R30,1
		subi R16,1
		brcc Convert_Loop
	sbiw R31:R30, 1

	lpm R16, Z

	pop R31
	pop R30

	ret