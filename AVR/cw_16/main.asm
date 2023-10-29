;
; by KK
;

ldi R20, 20

UpperLoop:
	ldi R21, 132
	LowerLoop:
		dec R21
		brbc 1, LowerLoop
	nop
	dec R20
	brbc 1, UpperLoop
	
; poprzednio program wykonywa³ siê w czasie 10 000 cykli/1Mhz=0,01s=10ms

; R20 - x, R21 -y
; x*(4 + y*3) =  8000
; solutions
; x = 20,  y = 132 
; x = 32,  y = 82
; x = 50,  y = 52
; x = 80,  y = 32
; x = 125, y = 20
; x = 200, y = 12