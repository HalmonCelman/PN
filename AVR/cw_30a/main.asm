;
; by KK
;

.macro LOAD_CONST
ldi @0, high(@2)
ldi @1,  low(@2)
.endmacro

; main program

ldi R18, 0b00111111 ; 0 on display
ldi R19, 0b00000110 ; 1 on display

ldi R20, 0x7F ; 0b01111111 - we dont need 1st bit
out DDRD, R20

ldi R20, 0b00011110
out DDRB, R20	; output
ldi R20, 0x02	; PB1
ldi R21, 0		; for clearing digits

LOAD_CONST R17,R16,0x00FA ; 256ms delay

InfLoop:
	out PORTB, R20  ; digit on
	out PORTD,R18
	rcall DelayInMs
	lsl R20
	cpi R20,0x20 ; if is > than PB4
	brlo InfLoop
	ldi R20, 0x02 ; than start from 1st one
	rjmp InfLoop

; subprograms

DelayInMs:
	push R17
	push R16
	InternalLoop:
		rcall DelayOneMs
		subi R16,1
		brbc 1,InternalLoop
		subi R17,1
		brcc InternalLoop
	pop R16
	pop R17
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

