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
	
main_loop
	ldr R0,=3
	bl delay_in_ms
	b main_loop
	
	; subprograms
delay_in_ms
	ldr R1, =15000
	mul R2,R1,R0
delay_loop
	subs R2, #1
	bne delay_loop
	bx lr ; return
	
	END
