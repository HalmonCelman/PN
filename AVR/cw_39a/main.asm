;
; by KK
;

; oho - czas na multiplexowanie

.macro LOAD_CONST
ldi @0, high(@2)
ldi @1,  low(@2)
.endmacro

.equ Digits_P=PORTB
.equ Segments_P=PORTD

.def Digit_0=R2
.def Digit_1=R3
.def Digit_2=R4
.def Digit_3=R5

ldi R16, 9
mov R2, R16
ldi R16, 8
mov R3, R16
ldi R16, 7
mov R4, R16
ldi R16, 6
mov R5, R16

; const values
; digits on display
Data: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

; initialization
ldi R20, 0x7F ; 0b01111111 - we dont need 1st bit
out DDRD, R20

ldi R20, 0b00011110
out DDRB, R20	; output
ldi R20, 0x02	; PB1
ldi R21, 0		; for clearing digits

LOAD_CONST R25,R24,0x0005 ; 1/50 = 20 ms => 20ms/4 = 5ms delay <-- ****************** tutaj zmiana

; infinite loop
InfLoop:
	out Digits_P, R20  ; digit on

	sbic Digits_P, 1		; idk czemu ale w cwiczeniu chca na odwrot... 9137->7319
		mov R16, Digit_3
	sbic Digits_P, 2
		mov R16, Digit_2
	sbic Digits_P, 3
		mov R16, Digit_1
	sbic Digits_P, 4
		mov R16, Digit_0

	rcall DigitTo7segCode
	out Segments_P,R16

	rcall DelayInMs
	lsl R20 ; shift left
	cpi R20,0x20 ; if is > than PB4
	brlo InfLoop
	ldi R20, 0x02 ; than start from 1st one
	rjmp InfLoop

; subprograms


DelayInMs:
	push R25
	push R24
	InternalLoop:
		rcall DelayOneMs
		sbiw R25:R24,1
		brbc 1,InternalLoop
	pop R24
	pop R25
	ret

DelayOneMs:
	push R25
	push R24
	ldi R25, 6
	ldi R24, 59
	CombinedLoop:
		sbiw R25:R24, 1
		nop
		brcc CombinedLoop
	pop R24
	pop R25
	nop
	nop
	nop
	nop
	ret

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