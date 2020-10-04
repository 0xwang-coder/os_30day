; naskfunc
; TAB=4
global	io_hlt

section .text
section .data

io_hlt:	; void io_hlt(void);
		HLT
		RET
