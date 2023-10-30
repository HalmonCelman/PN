;
; by KK
;

in R16,DDRB
ori R16,0b00011110
out DDRB,R16	; config as output
mov R17,R16
neg R17
dec R17	; because neg is substracting from 256 not 255
InfLoop:
	in R18,PORTB
	or R18,R16
	out PORTB,R18
	; there can be some delay or sth
	in R18,PORTB
	and R18,R17
	out PORTB,R18
	rjmp InfLoop

; ten program cyklicznie w³¹cza i wy³¹cza(na raz) piny od 1 do 4 na porcie B