;
; by KK
;


MainLoop:
	rcall DelayNCycles 
	rjmp MainLoop
DelayNCycles: 
	nop
	nop
	rcall SomeDummySubprogram
	nop
	ret 
SomeDummySubprogram:
	ldi R16,22
	ldi R17,07
	ldi R18,20
	ldi R19,04
	ret

; adresy powrot�w si� zgadzaj� - przy pocz�tkowym SP=0xDF
; pod adresem 0xFFDE jest zapisana warto�� 0x0001
; pod adresem 0xFFDC jest zapisana warto�� 0x0005