;
; by KK 
;
; pierwsze kolokwium napisane drugi raz w celach treningowych

;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
ldi @0, low(@2)
ldi @1, high(@2)
.ENDMACRO 

/*** Display ***/
.equ DigitsPort           =  PORTB
.equ SegmentsPort         = PORTD
.equ DisplayRefreshPeriod = 5

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
	LOAD_CONST R16,R17, DisplayRefreshPeriod
	rcall DealyInMs

	ldi R16, (2<<@0)
	out DigitsPort, R16

	mov R16, Dig_@0
	rcall DigitTo7segCode
	out SegmentsPort, R16
.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pami?ci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g??wnego
.org OC1Aaddr	rjmp  _Timer_ISR
.org PCIBaddr   rjmp  _ExtInt_ISR ; skok do procedury obs?ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs?ugi przerwania zewnetrznego
push R24
push R25
in R25, SREG
push R25

mov R24, PulseEdgeCtrL
mov R25, PulseEdgeCtrH

adiw R25:R24,1

mov PulseEdgeCtrL,R24
mov PulseEdgeCtrH, R25

pop R25
out SREG, R25
pop R25
pop R24

reti   ; powr?t z procedury obs?ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    push R16
    push R17
    push R18
    push R19

    mov R16, PulseEdgeCtrL
	mov R17, PulseEdgeCtrH
	rcall _NumberToDigits

	mov Dig_0,R16
	mov Dig_1,R17
	mov Dig_2,R18
	mov Dig_3,R19

	clr PulseEdgeCtrL
	clr PulseEdgeCtrH


	pop R19
    pop R18
    pop R17
    pop R16

  reti

; ### MAIN PROGAM ###

_main: 
    ; *** Initialisations ***
	
    ;--- Ext. ints --- PB0
    ldi R16, (1<<5)
	out GIMSK, R16
	ldi R16, 1
	out PCMSK0, R16

	;--- Timer1 --- CTC with 256 prescaller
    ldi R16, 0x0C
	out TCCR1B, R16

	ldi R16, 0x3D
	out OCR1AH, R16
	ldi R16, 0x09
	out OCR1AL, R16
	ldi R16, (1<<6)
	out TIMSK, R16
	
	;---  Display  --- 
	ldi R16, 0x7F
	out DDRD,R16
	ldi R16, 0x1E
	out DDRB, R16

	; --- enable gloabl interrupts
    sei

MainLoop:   ; presents Digit0-3 variables on a Display
			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;converts number to coresponding digits
;input/otput: R16-17/R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

_NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	; thousands 
	LOAD_CONST R18,R19,1000
	rcall _Divide
	mov Dig0, QL
	; hundreads 
    LOAD_CONST R18,R19,100
	rcall _Divide
	mov Dig1, QL
	; tens 
    LOAD_CONST R18,R19,10
	rcall _Divide
	mov Dig2, QL

	; ones 
    mov Dig3, RL

	; otput result
	mov R16,Dig0
	mov R17,Dig1
	mov R18,Dig2
	mov R19,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

	ret

;*** Divide ***
; divide 16-bit nr by 16-bit nr; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident  
.def XH=R17 

.def YL=R18 ; divider
.def YH=R19 

; outputs

.def RL=R16 ; reminder 
.def RH=R17 

.def QL=R18 ; quotient
.def QH=R19 

; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:push R24 ;save internal variables on stack
        push R25
		
        clr QCtrL
		clr QCtrH
	DoItAgain:
		cp YH,XH
		brlo DoIt
		cp XL,YL
		brlo End
	DoIt:
		sub XL,YL
		sbc XH,YH
		adiw QCtrH:QCtrL,1
		rjmp DoItAgain
	End:
		mov QL,QCtrL
		mov QH,QCtrH

		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

    ldi R30, low(Table<<1)
	ldi R31, high(Table<<1)

	add R30, R16
	ldi R16, 0
	adc R31, R16
	lpm R16,Z

pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DealyInMs:  
            push R24
			push R25

            mov R24, R16
			mov R25, R17
			dec R16
	DelayLoop:
			rcall OneMsLoop
			sbiw R25:R24, 1
			brbc 1,DelayLoop

			pop R25
			pop R24

			ret

; *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R24,R25,2000                    

L1:			SBIW R24:R25,1 
			BRNE L1

			pop R25
			pop R24

			ret



