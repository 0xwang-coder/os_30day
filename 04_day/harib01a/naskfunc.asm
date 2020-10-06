; naskfunc
; TAB=4

section .data
section .text
	global	io_hlt,write_mem8

io_hlt:	; void io_hlt(void);
	HLT
	RET

write_mem8:	; void write_mem8(int addr, int data);
	MOV		ECX,[ESP+4]		;
	MOV		AL,[ESP+8]		;
	MOV		[ECX],AL
	RET
