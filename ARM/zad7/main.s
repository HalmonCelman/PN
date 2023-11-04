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
	
CURRENT_DIGIT rn R12
	
	ldr R4, =IO0DIR
	ldr R5, =0x000F0000	; piny 16-19 port 0
	str R5, [R4]
	
	ldr R4, =IO1DIR
	ldr R5, =0x00FF0000	; piny 16-23 port 1
	str R5, [R4]
	
	ldr R4, =IO1SET		; setup digit
	ldr R5, =0x003F0000	; let's display '0'
	str R5, [R4]
	
	ldr CURRENT_DIGIT, =0 ; first digit
	
	; main_loop:
main_loop
	adr R6, digits
	add R5, CURRENT_DIGIT, R6
	ldrb R6, [R5]

	; IO0CLR = 0xf0000 // wygaszenie wszystkich wyswietlaczy
	ldr R4, =IO0CLR		
	ldr R5, =0x0F0000
	str R5, [R4]
	
	; IO0SET = 0x80000 >> CURRENT_DIGIT
	ldr R4, =IO0SET	
	ldr R5, =0x80000
	mov R5, R5,lsr CURRENT_DIGIT
	str R5, [R4]
	
	; CURRENT_DIGIT = (CURRENT_DIGIT+1)%4 // inkrementacja licznika cyfr,
	add CURRENT_DIGIT, #1
	cmp CURRENT_DIGIT, #4
	ldrhs CURRENT_DIGIT, =0
	
	; R0=500; // op�znienie
	ldr R0,=500
	
	; Delay(R0)
	bl delay_in_ms
	
	; jmp main_loop
	b main_loop
	
	; subprograms
delay_in_ms
	ldr R1, =15000
	mul R2,R1,R0
delay_loop
	subs R2, #1
	bne delay_loop
	bx lr ; return

digits dcb 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f
	END


