; naskfunc
; TAB=4
global	io_hlt
section .data
section .text

io_hlt:	; void io_hlt(void);
	HLT
	RET
