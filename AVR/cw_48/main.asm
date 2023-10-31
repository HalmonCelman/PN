;
; by KK
;

.cseg ; segment pamiêci kodu programu
.org 0 rjmp _main				; skok do programu g³ównego
.org OC1Aaddr rjmp _timer_isr	; skok do obs³ugi przerwania timera
.org 0x0B rjmp _pcint0_isr		; PCINT0 - as in datasheet in interrupt vectors

; krotkie wytlumaczenie - kiedy w jakims momencie glowny program zostaje przerwany to powinno sie zapisac rowniez flagi
; ktore byly w tym momencie ustawione bo moze pozniej np nie nastapic skok ktory powinien nastapic
;	przyklad:
;	ldi R16,255
;   addi R16,1	-> flaga carry ustawiona
;	<--- tu nastepuje przerwanie ktore nie zapisuje SREG i w rezultacie zeruje flage carry --->
;	brcs gdzies	-> bez przerwania powinno skoczyc do etykiety gdzies, ale przez przerwanie nie skacze
;
; poniewaz im wieksza czestotliwosc tym czesciej jest przerwanie to ten efekt byl bardziej widoczny przy duzych czestotliwosciach
; przejawial sie np tym ze wyswietlana byla tylko jedna cyfra - ktora nie byla tez za bardzo odswierzana

_pcint0_isr:
	push R26
	push R27

	in R27,SREG	; save flags
	push R27
	; increment
	mov R27, PulseEdgeCtrH	; prepare number for displaying
	mov R26, PulseEdgeCtrL

	adiw R27:R26,1

	cpi R27, 3
	brlo EndOfInterrupt
	cpi R26, 0xE8 ; 0x3E8 = 1000 in decimal
	brlo EndOfInterrupt
	clr R27
	clr R26

	EndOfInterrupt:
	mov PulseEdgeCtrH, R27
	mov PulseEdgeCtrL, R26

	pop R27
	out SREG, R27	; restore flags

	pop R27
	pop R26
	reti

_timer_isr: ; procedura obs³ugi przerwania timera
	push R16
	push R17
	push R18
	push R19
	
	in R19,SREG	; save flags
	push R19

	mov R17, PulseEdgeCtrH	; prepare number for displaying
	mov R16, PulseEdgeCtrL

	rcall NumberToDigits
	
	mov Digit_3, R16		; convert result to good format
	mov Digit_2, R17
	mov Digit_1, R18
	mov Digit_0, R19
	
	pop R19
	out SREG, R19 ; restore flags

	pop R19
	pop R18
	pop R17
	pop R16
	reti 

; const values
.equ Digits_P=PORTB
.equ Segments_P=PORTD

.def Digit_0=R2
.def Digit_1=R3
.def Digit_2=R4
.def Digit_3=R5

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1


; macros
.macro LOAD_CONST
	ldi @0, high(@2)
	ldi @1,  low(@2)
.endmacro

.macro SET_DIGIT
	rcall DelayInMs

	in R19, Digits_P
	andi R19,1
	ldi R20,(2<<@0)
	or R20,R19
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

.endmacro

; digits on display
Data: .db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F


_main:
ldi R16, (1<<5)		; PCIE0 enable
out GIMSK, R16

ldi R16, 1		; PCINT0 enable
out PCMSK0, R16

; timer init
ldi R16, 0b00001100	; CTC, PSC=256
out TCCR1B, R16

ldi R16, 0x7A		; 8000000/256 = 31250 = 0x7A12
out OCR1AH, R16 
ldi R16, 0x12		
out OCR1AL, R16 

ldi R16, (1<<6)		; OCIE1A enable
out TIMSK, R16

sei					; interrupts on

; initialization
ldi R20, 0x7F ; 0b01111111 - we dont need 1st bit
out DDRD, R20

ldi R20, 0b00011110
out DDRB, R20	; output
ldi R20, 0x02	; PB1
ldi R21, 0		; for clearing digits

LOAD_CONST R27,R26,5 ; 0 at start
LOAD_CONST R25,R24,5 ; 50Hz
; infinite loop
MainLoop:
	
	SET_DIGIT 0
	SET_DIGIT 1
	SET_DIGIT 2
	SET_DIGIT 3

	rjmp MainLoop

; subprograms

;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide
; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25 ;

;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25
; inputs
.def XL=R16 ; divident
.def XH=R17
.def YL=R18 ; divisor
.def YH=R19
; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19
; internal
.def QCtrL=R24
.def QCtrH=R25


NumberToDigits:
	push Dig0
	push Dig1
	push Dig2
	push Dig3
	
	LOAD_CONST YH,YL,1000
	rcall Divide
	mov Dig0,QL

	LOAD_CONST YH,YL,100
	rcall Divide
	mov Dig1,QL

	LOAD_CONST YH,YL,10
	rcall Divide
	mov Dig2,QL
	mov Dig3,RL

	mov R16,Dig0
	mov R17,Dig1
	mov R18,Dig2
	mov R19,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0
	ret




Divide:
	push QCtrL
	push QCtrH

	clr QCtrL	; 1. Quotient=0
	clr QCtrH

	DivideLoop:
		cp XH, YH			; 2. while(Divident>=Divisor){
		brlo EndOfDivision
		brne DivideGreater
		cp XL, YL
		brlo EndOfDivision
		
		DivideGreater:
		
		
		sub XL, YL			; 3. Divident = Divident - Divisor;
		sbc XH, YH

		adiw  QCtrH:QCtrL,1 ; 4. Quotient++;
		rjmp DivideLoop		; 5. }

	EndOfDivision:
	mov QL, QCtrL
	mov QH, QCtrH

	; no need for Remainder = Divident?? because of doubling registers in .def, but ok
	mov RL, XL
	mov RH, XH
	; also memory protection not needed ?? - value wouldn't change otherwise
	pop QCtrH
	pop QCtrL

	ret

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