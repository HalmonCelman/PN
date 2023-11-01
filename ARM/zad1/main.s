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
	
	ldr R1, =1000
	
main_loop		; remember to put labels at begining of the line - no preceding spaces
	subs R1, #1
	bne main_loop
	
	nop
	nop
	
	END

