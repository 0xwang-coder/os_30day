;[FORMAT "WCOFF"]				; 
;[INSTRSET "i486p"]				; 
;[BITS 32]						; 
;[FILE "a_nask.nas"]			; 

	global	api_putchar

;[SECTION .text]

api_putchar:	; void api_putchar(int c);
	MOV		EDX,1
	MOV		AL,[ESP+4]		; c
	INT		0x40
	RET
