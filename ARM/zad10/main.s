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

DIGIT_0 rn R8
DIGIT_1 rn R9
DIGIT_2 rn R10
DIGIT_3 rn R11

	; ustawienie pinów sterujacych wyswietlaczem na wyjsciowe
	ldr R4, =IO0DIR
	ldr R5, =0x000F0000	; piny 16-19 port 0
	str R5, [R4]
	
	ldr R4, =IO1DIR
	ldr R5, =0x00FF0000	; piny 16-23 port 1
	str R5, [R4]
	
	ldr R4, =IO1SET		; setup digit
	ldr R5, =0x003F0000	; let's display '0'
	str R5, [R4]
	
	; inicjalizacja licznika dekadowego
	ldr DIGIT_0, =0
	ldr DIGIT_1, =0
	ldr DIGIT_2, =0
	ldr DIGIT_3, =0
	
	; wyzerowanie licznika cyfr
	ldr CURRENT_DIGIT, =0
	
	; main_loop:
main_loop
	; IO0CLR = 0xf0000 // wygaszenie wszystkich wyswietlaczy
	ldr R4, =IO0CLR		
	ldr R5, =0x0F0000
	str R5, [R4]
	
	; IO1CLR = 0xff0000 // wygaszenie wszystkich segmentow
	ldr R4, =IO1CLR		
	ldr R5, =0x0FF0000
	str R5, [R4]
	
	; wlaczenie cyfry o numerze podanym w CURR_DIG,
	ldr R4, =IO0SET	
	ldr R5, =0x80000
	mov R5, R5,lsr CURRENT_DIGIT
	str R5, [R4]
	
	cmp CURRENT_DIGIT, #0
		moveq R6, DIGIT_0
	cmp CURRENT_DIGIT, #1
		moveq R6, DIGIT_1
	cmp CURRENT_DIGIT, #2
		moveq R6, DIGIT_2
	cmp CURRENT_DIGIT, #3
		moveq R6, DIGIT_3
	
	; zamiana numeru cyfry (CURR_DIG) na kod siedmiosegmentowy (R6)
	adr R4, digits
	add R5, R6, R4
	ldrb R6, [R5]
	
	; wpisanie kodu siedmiosegmentowego (R6) do segmentów
	ldr R4, =IO1SET
	mov R6, R6,lsl#16
	str R6, [R4]
	
	; inkrementacja licznika dekadowego (DIGIT_0 .. DIGIT_3)
	add DIGIT_0, #1
	cmp DIGIT_0, #10
	blo eoinc
	
	ldr DIGIT_0, =0
	add DIGIT_1, #1
	cmp DIGIT_1, #10
	blo eoinc
	
	ldr DIGIT_1, =0
	add DIGIT_2, #1
	cmp DIGIT_2, #10
	blo eoinc
	
	ldr DIGIT_2, =0
	add DIGIT_3, #1
	cmp DIGIT_3, #10
	ldrhs DIGIT_3, =0
	
	
eoinc	; end of incrementing
	; inkrementacja licznika cyfr (CURR_DIG) modulo 4
	add CURRENT_DIGIT, #1
	cmp CURRENT_DIGIT, #4
	ldrhs CURRENT_DIGIT, =0
	
	; opóznienie
	ldr R0,=5
	bl delay_in_ms
	
	b main_loop
	
	; podprogram delay_in_ms
delay_in_ms
	ldr R1, =15000
	mul R2,R1,R0
delay_loop
	subs R2, #1
	bne delay_loop
	bx lr ; return
	
	; tablica kodów siedmiosegmentowych
digits dcb 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f
	END


