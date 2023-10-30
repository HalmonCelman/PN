;
; by KK
;


; macros
.macro LOAD_CONST
	ldi @0, high(@2)
	ldi @1,  low(@2)
.endmacro

; let's check if subprogram is working
LOAD_CONST XH,XL,1200
LOAD_CONST YH,YL,500
rcall Divide
nop

; subprograms

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