$NOMOD51					; nu foloseste definitiile SFR pentru 8051 clasic

;-----------------------------------------------------------------------------
;  FILE NAME   :  LED.ASM 
;  TARGET MCU  :  C8051F040 
;  DESCRIPTION :  Acest program arata cum se dezactiveaza ceasul de garda, cum
;				  se configureaza un port si cum se comanda un pin de iesire.
;-----------------------------------------------------------------------------
$include (c8051f040.inc)	; Include fisierul cu definitiile SFR

;-----------------------------------------------------------------------------
; EQUATES
;-----------------------------------------------------------------------------
LED_PIN	equ	P2.5            ; Se foloseste pinul 0 din Portul 1.	

;-----------------------------------------------------------------------------
; Segment de cod absolut - fixare punct de intrare in program la resetare
;-----------------------------------------------------------------------------
		cseg 	AT 0	; Instructiunea urmatoare va fi amplasata la adresa 0000h
		mov SFRPAGE, 	#01h
		mov TMR3CN, #10000100b 
		mov TMR3CF, #00000000b
		MOV IE, #0x88  ; Enable EA (global interrupts) and ET3 (Timer 3 overflow interrupt)

		SETB EA
		SETB TR3



		ljmp	Main	; Salt la inceputul programului principal
						; (peste eventuali vectori de intrerupere)

;-----------------------------------------------------------------------------
; CODE SEGMENT	 - segment de cod relocabil
;-----------------------------------------------------------------------------
Led		segment  CODE	; LED este un segment de cod relocabil

		rseg	Led		; selecteaza segmentul de cod relocabil LED
		using	0		; precizeaza bancul de registre folosit

Main:	; Dezactiveaza ceasul de garda (WDT) - dupa resetare e automat activat.
		mov		WDTCN, #0DEh
		mov		WDTCN, #0ADh

		; Selecteaza SFR din pagina de configurare (F)
		mov		SFRPAGE, #CONFIG_PAGE

		; Activeaza Port I/O Crossbar - conecteaza perifericele interne la pini
		mov		XBR2, #40h

		; Configureaza P1 ca iesire digitala in modul push-pull.  
		mov		P2MDOUT,#0FFh 

		; Pune initial P1 pe OFF
		mov		P2,#05h

		


		jmp Main

		  ; Define the Timer 3 overflow interrupt handler
		ORG 0B3H
	TIMER3_ISR:
    	MOV P3, #0ffh 
    RETI
END