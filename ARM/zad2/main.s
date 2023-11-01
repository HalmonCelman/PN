;
; by KK
;
	AREA	MAIN_CODE, CODE, READONLY
	GET		LPC213x.s
		
	ENTRY
__main
__use_two_region_memory
	EXPORT			__main
	EXPORT			__use_two_region_memory
	
	ldr R0, =1
	ldr R1, =3000
	
	mul R2,R1,R0
	
main_loop
	subs R2, #1
	bne main_loop
	
	nop
	
	END
	
	; niedokladnosc - 4 cykle - maksymalnie 4/12000=0,0(3)%
