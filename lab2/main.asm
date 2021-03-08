;
; LAB2.asm
;
; Created: 3/1/2021 5:40:21 PM
; Author : mleyda
;


; Replace with your application code
.include "m328Pdef.inc"
.cseg
.org 0

.def counterA = r20
.def b_press = r21
.def b_release = r22
.def number = r19
.def counter = r18
.def press = r11
.def release = r12

; Configure output pins
sbi DDRD, 2   ; PB2is now output  SER
sbi DDRD, 3   ; PB3is now output  RCLK
sbi DDRD, 4   ; PB4is now output  SRCLK

cbi DDRD, 5       
cbi DDRD, 6       

clr number
clr counterA
clr b_press
clr b_release
clr counter 

ldi r16, 0b00111111
rcall display

main: 
	rcall debouncerA

	rjmp main



display:
    push r16
	push r17
	in r17, sreg
	push r17

	ldi r17, 8

loop: 
	rol R16;
	BRCS set_ser_in_1
	cbi PORTD, 2
	rjmp end

set_ser_in_1:
	sbi PORTD, 2
end:
	sbi PORTD, 4
	nop
	cbi	PORTD, 4

	dec R17
	brne loop

	sbi PORTD, 3
	nop
	cbi PORTD, 3

	pop R17
	out SREG, R17
	pop R17
	pop R16

	;rjmp main
	ret

reset: 
clr counter
ldi number, 0
rcall zero
ret

debouncerA:
	clr b_press
	clr b_release
	clr press
	clr release
	clr counterA

	loop2:
		in r31, PIND
		sbrc r31, 5;skip if not pressed
		inc b_press 

		sbrs r31, 5; skip if pressed
		inc b_release

		sbrc r31, 6;skip if not pressed
		inc press 

		sbrs r31, 6; skip if pressed
		inc release

		rcall delay_long ;10ms
		inc counterA

		cpi counterA, 60
		brne loop2

		cp b_press, b_release
		brpl setPressed 

		cp press, release
		brpl countdown

	ret

blink:
	rcall dash
	rcall delay_half

	rcall empty
	rcall delay_half
	inc counter
	
	cpi counter, 5
	brne blink
	
	cpi counter, 5
	breq reset

setPressed:
	ldi r30, 0

	loop3:
		in r31, PIND
		sbrc r31, 5 ; skip if button is released
		rcall helper2

		sbrs r31, 5 ;skip if button is not released
		rcall helper

		helper: 
			rcall inc_number
			rjmp main 
				
		helper2:
			cpi r30, 100
			breq reset

			rcall delay_long
			inc r30 
			rjmp loop3



delay1s:
	rcall delay_long
	inc counterA
		
	cpi counterA, 100
	brne delay1s
	ret

delay_half:
	clr counterA
	half_loop:
		rcall delay_long
		inc counterA

		cpi counter, 50
		brne half_loop
	ret

delay_long:
      ldi   r23,2  
  d1: ldi   r24,150
  d2: ldi   r25,105   
  d3: dec   r25 
	  nop   
	  nop           
      brne  d3 
      dec   r24
      brne  d2
      dec   r23
      brne  d1
      ret

inc_number:
	inc number
	rcall compare
	ret

countdown:
	clr counterA

	cpi number, 0
	breq end2

	rcall dec_number
	rcall delay1s

	cpi number, 0
	breq blink
	
	cpi number, 0
	brne countdown
	end2:
		ret

dec_number:
	dec number
	rcall compare
	ret


compare: 
	cpi number, 0
	breq zero

	cpi number, 1
	breq one

	cpi number, 2
	breq two

	cpi number, 3
	breq three

	cpi number, 4
	breq four

	cpi number, 5
	breq five

	cpi number, 6
	breq six

	cpi number, 7
	breq seven

	cpi number, 8
	breq eight

	cpi number, 9
	breq nine

	cpi number, 10
	breq ten

	cpi number, 11
	breq eleven

	cpi number, 12
	breq twelve

	cpi number, 13
	breq thirteen

	cpi number, 14
	breq fourteen

	cpi number, 15
	breq fifteen

	cpi number, 16
	breq sixteen

	cpi number, 17
	breq seventeen

	cpi number, 18
	breq eighteen

	cpi number, 19
	brsh nineteen

	ret

empty:
	ldi r16, 0b00000000
	rjmp display

dash:
	ldi r16, 0b01000000
	rjmp display
zero:
	clr number
	ldi r16, 0b00111111
	rjmp display
one: 
	ldi r16, 0b00000110
	rjmp display
two: 
	ldi r16, 0b01011011
	rjmp display
three: 
	ldi r16, 0b01001111
	rjmp display
four: 
	ldi r16, 0b01100110
	rjmp display
five:
	ldi r16, 0b01101101
	rjmp display
six:
	ldi r16, 0b01111101
	rjmp display
seven:
	ldi r16, 0b00000111
	rjmp display
eight:
	ldi r16, 0b01111111
	rjmp display
nine:
	ldi r16, 0b01101111
	rjmp display
ten:
	ldi r16, 0b10111111
	rjmp display
eleven:
	ldi r16, 0b10000110
	rjmp display
twelve:
	ldi r16, 0b11011011
	rjmp display
thirteen: 
	ldi r16, 0b11001111
	rjmp display
fourteen:
	ldi r16, 0b11100110
	rjmp display
fifteen:
	ldi r16, 0b11101101
	rjmp display
sixteen:
	ldi r16, 0b11111101
	rjmp display
seventeen:
	ldi r16, 0b10000111
	rjmp display
eighteen:
	ldi r16, 0b11111111
	rjmp display
nineteen:
	ldi r16, 0b11101111
	rjmp display