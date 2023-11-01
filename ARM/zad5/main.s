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
	
	ldr R4, =IO0DIR
	ldr R5, =0x000F0000	; piny 16-19 port 0
	str R5, [R4]
	
	ldr R4, =IO1DIR
	ldr R5, =0x00FF0000	; piny 16-23 port 1
	str R5, [R4]
	
	ldr R4, =IO1SET		; setup digit
	ldr R5, =0x003F0000	; let's display '0'
	str R5, [R4]
	
	ldr R4, =IO0SET		; digit on
	ldr R5, =0x00010000	; on first digit
	str R5, [R4]
	
main_loop
	ldr R0,=3
	bl delay_in_ms
	b main_loop
	
	; subprograms
delay_in_ms
	ldr R1, =3000
	mul R2,R1,R0
delay_loop
	subs R2, #1
	bne delay_loop
	bx lr ; return
	
	END
