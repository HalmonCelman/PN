;
; by KK
;

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


; macros
.macro LOAD_CONST
	ldi @0, high(@2)
	ldi @1,  low(@2)
.endmacro

; let's check if subprogram is working
LOAD_CONST R17,R16,9876
rcall NumberToDigits
nop

; subprograms

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