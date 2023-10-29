;
; by KK
;


MainLoop:
	rcall DelayNCycles ;
	rjmp MainLoop
DelayNCycles: ;zwyk³a etykieta
	nop
	nop
	nop
	ret ; powrót do miejsca wywo³ania

; cykle potrzebne na wywo³anie i wykonanie podprogramu (razem z rcall i ret): 10
; czas 10/8000000 = 1,25uS
; cykle: rcall - 3,nop - 1,ret - 4 => 3+3*1+4=10