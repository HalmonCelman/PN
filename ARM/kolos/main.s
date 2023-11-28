		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory
		
;
		
CURRENT_DIGIT rn R12
DIG_0 rn R8
DIG_1 rn R9
DIG_2 rn R10
DIG_3 rn R11


		ldr R0, =IO0DIR
		ldr R1, =0xF0000
		str R1,[R0]
		
		ldr R0, =IO1DIR
		ldr R1, =0xFF0000
		str R1,[R0]
		
		ldr DIG_0, =0
		ldr DIG_1, =0
		ldr DIG_2, =0
		ldr DIG_3, =0
		
infloop
		ldr R0, =IO0CLR		;clr all displays
		ldr R1, =0xF0000
		str R1, [R0]
		
		ldr R0, =IO0SET
		ldr R1,=0x80000
		lsr R1,R1,CURRENT_DIGIT
		str R1, [R0]
		
		ldr R0, =IO1CLR		;clr all displays
		ldr R1, =0xFF0000
		str R1, [R0]
		
		cmp CURRENT_DIGIT,#0
		movcs R6,DIG_3
		cmp CURRENT_DIGIT,#1
		movcs R6,DIG_2
		cmp CURRENT_DIGIT,#2
		movcs R6,DIG_1
		cmp CURRENT_DIGIT,#3
		movcs R6,DIG_0
		
		adr R0, Table

		add R0,R0,R6
		ldrb R0,[R0]
		
		lsl R1,R0,#16
		ldr R0, =IO1SET
		str R1,[R0]
		
		add DIG_3,DIG_3,#1
		cmp DIG_3,#10
		ldrhs DIG_3, =0
		addhs DIG_2,DIG_2,#1
		cmp DIG_2,#10
		ldrhs DIG_2, =0
		addhs DIG_1,DIG_1,#1
		cmp DIG_1,#10
		ldrhs DIG_1, =0
		addhs DIG_0,DIG_0,#1
		
		
		add CURRENT_DIGIT,CURRENT_DIGIT,#1
		cmp CURRENT_DIGIT, #4
		ldrhs CURRENT_DIGIT, =0
		
		ldr R0,=100
		bl delay_in_ms
		
		b infloop
		
delay_in_ms
		
		ldr R2,=15000
		mul R1,R0,R2
delay_loop
		subs R1,R1,#1
		bne delay_loop
		
		bx lr

Table dcb 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f

		END
		

