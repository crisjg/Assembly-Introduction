#include<P18F4321.inc>
 config OSC = INTIO67
 config WDT = OFF
 config LVP = OFF
 config BOREN = OFF
Color_Off equ 0xFF ;<- replace OFF with proper value
OUTER_VALUE equ 0x10 ;<- value adjusted to reach 10ms
INNER_VALUE equ 0x9C;<- value adjusted to reach 10ms
Saved_D1_loc equ 0x22 ; memory address for saved Color for D1
Saved_D2_loc equ 0x23 ; memory address for saved Color for D2
Saved_OV_loc equ 0x24 ; memory address for saved Outer Value
Saved_IV_loc equ 0x25 ; memory address for saved Inner Value
 ORG 0x0000
; CODE STARTS FROM THE NEXT LINE
START:
 MOVLW  0x70
 MOVWF OSCCON
 

 
 MOVLW 0xFF ; Load W with 0xFF
 MOVWF TRISA ; Set PORT A as all inputs
 
 MOVLW 0x00 ; Load W with 0x00
 MOVWF TRISB ;Make PORT B bits 0-7 as outputs
 MOVWF TRISC ; Make PORT C bits 0-7 as outputs
 MOVWF TRISD ; Make PORT D bits 0-7 as outputs
 
 MOVLW 0x0F ; Load W with 0x0F
 MOVWF ADCON1 ; Set ADCON1


BIG_LOOP:
    BTFSC PORTA, 1 ;If Bit 0 of PORTA = 0 skip the next instruction
    GOTO  A1_1 ;else go to CASE A1_1 (PORTA Bit 0 = 1)

A1_0:
	BTFSC PORTA, 0 ;If PORTA = 0 go to CASE GREEN
	GOTO GREEN
RED:
	MOVLW 0x00 ; Load W with the desired color for PORTC
	MOVWF Saved_D1_loc ; save desired color into memory location Saved_D1_loc
	MOVLW (0xFE <<2) ; Load W with 0xFE shited two bits to load onto portD
	MOVWF Saved_D2_loc ; save desired color into memory location Saved_D2_loc
	    
	MOVLW OUTER_VALUE * 1 ; Load OUTER_VALUE into W
	MOVWF Saved_OV_loc ; save it to the memory location Saved_OV_loc
	MOVLW INNER_VALUE ; Load INNER_VALUE into W
	MOVWF Saved_IV_loc ; save it to the memory location Saved_IV_loc
	GOTO Common
	
	    
GREEN:
	MOVLW 0x00 ; Load W with the desired color for PORTC
	MOVWF Saved_D1_loc ; save desired color into memory location Saved_D1_loc
	MOVLW (0xFD << 2) ; Load W with 0xFD shited two bits to load onto portD
	MOVWF Saved_D2_loc ; save desired color into memory location Saved_D2_loc
	
	MOVLW OUTER_VALUE * 2 ; Load 2 * OUTER_VALUE into W to reach 20ms
	MOVWF Saved_OV_loc ; save it to the memory location Saved_OV_loc
	MOVLW INNER_VALUE ; Load INNER_VALUE into W
	MOVWF Saved_IV_loc ; save it to the memory location Saved_IV_loc
	GOTO Common

A1_1:
	BTFSC PORTA,0 ;If Bit 0 of PORTA = 1 skip the next instruction
	GOTO WHITE
	GOTO BLUE
	
BLUE:
	MOVLW 0x00 ; Load W with the desired color for PORTC
	MOVWF Saved_D1_loc ; save desired color into memory location Saved_D1_loc
	MOVLW (0xFB <<2) ; Load W with 0xFB shited two bits to load onto portD
	MOVWF Saved_D2_loc ; save desired color into memory location Saved_D2_loc
	    
	MOVLW OUTER_VALUE * 4 ; Load 4 * OUTER_VALUE into W to reah 40 ms
	MOVWF Saved_OV_loc ; save it to the memory location Saved_OV_loc
	MOVLW INNER_VALUE ; Load INNER_VALUE into W
	MOVWF Saved_IV_loc ; save it to the memory location Saved_IV_loc
	GOTO Common

WHITE:

	MOVLW 0x00 ; Load W with the desired color for PORTC
	MOVWF Saved_D1_loc ; save desired color into memory location Saved_D1_loc
	MOVLW (0x00) ; Load W with 0x00 to load onto portD
	MOVWF Saved_D2_loc ; save desired color into memory location Saved_D2_loc
	    
	MOVLW 0xA0 ; adjusted OUTER_VALUE into W to reach 100ms
	MOVWF Saved_OV_loc ; save it to the memory location Saved_OV_loc
	MOVLW INNER_VALUE ; Load INNER_VALUE into W
	MOVWF Saved_IV_loc ; save it to the memory location Saved_IV_loc
	GOTO Common    
    

Common:
        MOVLW 0x00 ; Load W with the desired color for PORTC
	MOVWF Saved_D1_loc ; save desired color into memory location Saved_D1_loc

    COLOR_LOOP:
    
     MOVFF Saved_D1_loc,PORTC ; Get saved color of PORTC and output to that Port
     MOVFF Saved_D2_loc ,PORTD ; Get saved color of PORTD and output to that Port
     MOVFF Saved_OV_loc,0x21 ; Copy saved outer loop value to 0x21
    ; NESTED DELAY LOOP TO HAVE THE FIRST HALF OF WAVEFORM
	    LOOP_OUTER_1:
	     NOP ; Do nothing
	     MOVFF Saved_IV_loc,0x20 ; Load saved inner loop value to 0x20
	    LOOP_INNER_1:
	     NOP ; Do nothing
	     DECF 0x20,F ; Decrement memory location 0x20
	     BNZ LOOP_INNER_1 ; If value not zero, go back to LOOP_INNER_1
	     DECF 0x21,F ; Decrement memory location 0x21
	     BNZ LOOP_OUTER_1 ; If value not zero, go back to LOOP_OUTER_1
	     MOVLW Color_Off ; Load W with the second desired color
	     MOVWF PORTC ; Output to PORT C to turn off the RGB LED D1
	     MOVWF PORTD ; Output to PORT D to turn off the RGB LED D2
	     MOVFF Saved_OV_loc,0x21 ; Copy saved outer loop value to 0x21
	    ; NESTED DELAY LOOP TO HAVE THE FIRST HALF OF WAVEFORM BEING LOW
	    LOOP_OUTER_2:
	     NOP ; Do nothing
	     MOVFF Saved_IV_loc,0x20 ; Load saved inner loop value to 0x20
	    LOOP_INNER_2:
	     NOP ; Do nothing
	     DECF 0x20,F ; Decrement memory location 0x20
	     BNZ LOOP_INNER_2 ; If value not zero, go back to LOOP_INNER_2
	     DECF 0x21,F ; Decrement memory location 0x21
	     BNZ LOOP_OUTER_2 ; If value not zero, go back to LOOP_OUTER_2
	    ; START ALL OVER AGAIN
	     GOTO BIG_LOOP ; Go back to main loop
 END 





