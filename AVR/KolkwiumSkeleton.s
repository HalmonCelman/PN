 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
 ; TBD
.ENDMACRO 

/*** Display ***/
.equ DigitsPort             ; TBD
.equ SegmentsPort           ; TBD
.equ DisplayRefreshPeriod   ; TBD

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
 ; TBD
.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp  ; TBD
.org PCIBaddr   rjmp  ; TBD ; skok do procedury obs³ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs³ugi przerwania zewnetrznego

 ; TBD

reti   ; powrót z procedury obs³ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    push R16
    push R17
    push R18
    push R19

    ; TBD

	pop R19
    pop R18
    pop R17
    pop R16

  reti

; ### MAIN PROGAM ###

_main: 
    ; *** Initialisations ***

    ;--- Ext. ints --- PB0
    ; TBD

	;--- Timer1 --- CTC with 256 prescaller
    ; TBD
			
	;---  Display  --- 

	; --- enable gloabl interrupts
    ; TBD

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
    ; TBD

	; hundreads 
    ; TBD     

	; tens 
    ; TBD    

	; ones 
    ; TBD

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
		
        ; TBD

		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

    ; TBD

pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DealyInMs:  
            push R24
			push R25

            ; TBD

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



