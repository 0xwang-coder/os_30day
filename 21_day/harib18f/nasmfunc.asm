; naskfunc
; TAB=4

section .data

section .text
	global	io_hlt, io_cli, io_sti, io_stihlt
	global	io_in8,  io_in16,  io_in32
	global	io_out8, io_out16, io_out32
	global	io_load_eflags, io_store_eflags
	global	load_gdtr, load_idtr
	global	load_tr
	global  farjmp, farcall
	global  load_cr0, store_cr0
	global	asm_inthandler20, asm_inthandler21, asm_inthandler27, asm_inthandler2c
	global  memtest_sub
	global  asm_cons_putchar
	global  asm_hrb_api, start_app, asm_inthandler0d
	EXTERN	inthandler20, inthandler21, inthandler27, inthandler2c
	EXTERN	cons_putchar
	EXTERN	hrb_api, inthandler0d

io_hlt:	; void io_hlt(void);
	HLT
	RET

io_cli:	; void io_cli(void);
	CLI
	RET

io_sti:	; void io_sti(void);
	STI
	RET

io_stihlt:	; void io_stihlt(void);
	STI
	HLT
	RET

io_in8:	; int io_in8(int port);
	MOV		EDX,[ESP+4]		; port
	MOV		EAX,0
	IN		AL,DX
	RET

io_in16:	; int io_in16(int port);
	MOV		EDX,[ESP+4]		; port
	MOV		EAX,0
	IN		AX,DX
	RET

io_in32:	; int io_in32(int port);
	MOV		EDX,[ESP+4]		; port
	IN		EAX,DX
	RET

io_out8:	; void io_out8(int port, int data);
	MOV		EDX,[ESP+4]		; port
	MOV		AL,[ESP+8]		; data
	OUT		DX,AL
	RET

io_out16:	; void io_out16(int port, int data);
	MOV		EDX,[ESP+4]		; port
	MOV		EAX,[ESP+8]		; data
	OUT		DX,AX
	RET

io_out32:	; void io_out32(int port, int data);
	MOV		EDX,[ESP+4]		; port
	MOV		EAX,[ESP+8]		; data
	OUT		DX,EAX
	RET

io_load_eflags:	; int io_load_eflags(void);
	PUSHFD		; PUSH EFLAGS �Ƃ����Ӗ�
	POP		EAX
	RET

io_store_eflags:	; void io_store_eflags(int eflags);
	MOV		EAX,[ESP+4]
	PUSH	EAX
	POPFD		; POP EFLAGS �Ƃ����Ӗ�
	RET

load_gdtr:		; void load_gdtr(int limit, int addr);
	MOV		AX,[ESP+4]		; limit
	MOV		[ESP+6],AX
	LGDT	[ESP+6]
	RET

load_idtr:		; void load_idtr(int limit, int addr);
	MOV		AX,[ESP+4]		; limit
	MOV		[ESP+6],AX
	LIDT	[ESP+6]
	RET

load_cr0:		; int load_cr0(void);
	MOV		EAX,CR0
	RET

store_cr0:		; void store_cr0(int cr0);
	MOV		EAX,[ESP+4]
	MOV		CR0,EAX
	RET

asm_inthandler20:
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV		AX,SS
	CMP		AX,1*8
	JNE		.from_app
;	OS
	MOV		EAX,ESP
	PUSH	SS				; SS
	PUSH	EAX				; ESP
	MOV		AX,SS
	MOV		DS,AX
	MOV		ES,AX
	CALL	inthandler20
	ADD		ESP,8
	POPAD
	POP		DS
	POP		ES
	IRETD
.from_app:
	MOV		EAX,1*8
	MOV		DS,AX			; DS OS
	MOV		ECX,[0xfe4]		; OS ESP
	ADD		ECX,-8
	MOV		[ECX+4],SS		; SS
	MOV		[ECX  ],ESP		; ESP
	MOV		SS,AX
	MOV		ES,AX
	MOV		ESP,ECX
	CALL	inthandler20
	POP		ECX
	POP		EAX
	MOV		SS,AX			; SS
	MOV		ESP,ECX			; ESP
	POPAD
	POP		DS
	POP		ES
	IRETD

asm_inthandler21:
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV		EAX,ESP
	PUSH	EAX
	MOV		AX,SS
	MOV		DS,AX
	MOV		ES,AX
	CALL	inthandler21
	POP		EAX
	POPAD
	POP		DS
	POP		ES
	IRETD

asm_inthandler27:
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV		EAX,ESP
	PUSH	EAX
	MOV		AX,SS
	MOV		DS,AX
	MOV		ES,AX
	CALL	inthandler27
	POP		EAX
	POPAD
	POP		DS
	POP		ES
	IRETD

asm_inthandler2c:
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV		EAX,ESP
	PUSH	EAX
	MOV		AX,SS
	MOV		DS,AX
	MOV		ES,AX
	CALL	inthandler2c
	POP		EAX
	POPAD
	POP		DS
	POP		ES
	IRETD

memtest_sub:	; unsigned int memtest_sub(unsigned int start, unsigned int end)
	PUSH	EDI						; EBX, ESI, EDI
	PUSH	ESI
	PUSH	EBX
	MOV		ESI,0xaa55aa55			; pat0 = 0xaa55aa55;
	MOV		EDI,0x55aa55aa			; pat1 = 0x55aa55aa;
	MOV		EAX,[ESP+12+4]			; i = start;
mts_loop:
	MOV		EBX,EAX
	ADD		EBX,0xffc				; p = i + 0xffc;
	MOV		EDX,[EBX]				; old = *p;
	MOV		[EBX],ESI				; *p = pat0;
	XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
	CMP		EDI,[EBX]				; if (*p != pat1) goto fin;
	JNE		mts_fin
	XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
	CMP		ESI,[EBX]				; if (*p != pat0) goto fin;
	JNE		mts_fin
	MOV		[EBX],EDX				; *p = old;
	ADD		EAX,0x1000				; i += 0x1000;
	CMP		EAX,[ESP+12+8]			; if (i <= end) goto mts_loop;
	JBE		mts_loop
	POP		EBX
	POP		ESI
	POP		EDI
	RET
mts_fin:
	MOV		[EBX],EDX				; *p = old;
	POP		EBX
	POP		ESI
	POP		EDI
	RET

load_tr:		; void load_tr(int tr);
	LTR		[ESP+4]			; tr
	RET

farjmp:		; void farjmp(int eip, int cs);
	JMP		FAR	[ESP+4]				; eip, cs
	RET

asm_cons_putchar:
	PUSH	1
	AND		EAX,0xff	; 
	PUSH	EAX
	PUSH	DWORD [0x0fec]	; 
	CALL	cons_putchar
	ADD		ESP,12		; 
	RETF

farcall:		; void farcall(int eip, int cs);
	CALL	FAR	[ESP+4]				; eip, cs
	RET

asm_hrb_api:
	; 
	PUSH	DS
	PUSH	ES
	PUSHAD					; �ۑ��̂��߂�PUSH
	MOV		EAX,1*8
	MOV		DS,AX			; �Ƃ肠����DS����OS�p�ɂ���
	MOV		ECX,[0xfe4]		; OS��ESP
	ADD		ECX,-40
	MOV		[ECX+32],ESP	; �A�v����ESP��ۑ�
	MOV		[ECX+36],SS		; �A�v����SS��ۑ�

; PUSHAD
	MOV		EDX,[ESP   ]
	MOV		EBX,[ESP+ 4]
	MOV		[ECX   ],EDX	; hrb_api
	MOV		[ECX+ 4],EBX	; hrb_api
	MOV		EDX,[ESP+ 8]
	MOV		EBX,[ESP+12]
	MOV		[ECX+ 8],EDX	; hrb_api
	MOV		[ECX+12],EBX	; hrb_api
	MOV		EDX,[ESP+16]
	MOV		EBX,[ESP+20]
	MOV		[ECX+16],EDX	; hrb_api
	MOV		[ECX+20],EBX	; hrb_api
	MOV		EDX,[ESP+24]
	MOV		EBX,[ESP+28]
	MOV		[ECX+24],EDX	; hrb_api
	MOV		[ECX+28],EBX	; hrb_api

	MOV		ES,AX			; 
	MOV		SS,AX
	MOV		ESP,ECX
	STI						; 

	CALL	hrb_api

	MOV		ECX,[ESP+32]	; ESP
	MOV		EAX,[ESP+36]	; SS�
	CLI
	MOV		SS,AX
	MOV		ESP,ECX
	POPAD
	POP		ES
	POP		DS
	IRETD					; STI

start_app:		; void start_app(int eip, int cs, int esp, int ds);
	PUSHAD		; 32
	MOV		EAX,[ESP+36]	; EIP
	MOV		ECX,[ESP+40]	; CS
	MOV		EDX,[ESP+44]	; ESP
	MOV		EBX,[ESP+48]	; DS/SS
	MOV		[0xfe4],ESP		; OS ESP
	CLI						; 
	MOV		ES,BX
	MOV		SS,BX
	MOV		DS,BX
	MOV		FS,BX
	MOV		GS,BX
	MOV		ESP,EDX
	STI						; 
	PUSH	ECX				; far-CALL PUSH ics
	PUSH	EAX				; far-CALL PUSH ieip
	CALL	FAR [ESP]		; 

;

	MOV		EAX,1*8			; OS DS/SS
	CLI					; 
	MOV		ES,AX
	MOV		SS,AX
	MOV		DS,AX
	MOV		FS,AX
	MOV		GS,AX
	MOV		ESP,[0xfe4]
	STI					; 
	POPAD				; 
	RET

asm_inthandler0d:
	STI
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV		AX,SS
	CMP		AX,1*8
	JNE		.from_app
;	OS
	MOV		EAX,ESP
	PUSH	SS				; SS
	PUSH	EAX				; ESP
	MOV		AX,SS
	MOV		DS,AX
	MOV		ES,AX
	CALL	inthandler0d
	ADD		ESP,8
	POPAD
	POP		DS
	POP		ES
	ADD		ESP,4			; INT 0x0d
	IRETD
.from_app:
;	
	CLI
	MOV		EAX,1*8
	MOV		DS,AX			; DS
	MOV		ECX,[0xfe4]		; OS ESP
	ADD		ECX,-8
	MOV		[ECX+4],SS		; SS
	MOV		[ECX  ],ESP		; ESP
	MOV		SS,AX
	MOV		ES,AX
	MOV		ESP,ECX
	STI
	CALL	inthandler0d
	CLI
	CMP		EAX,0
	JNE		.kill
	POP		ECX
	POP		EAX
	MOV		SS,AX			; SS
	MOV		ESP,ECX			; ESP
	POPAD
	POP		DS
	POP		ES
	ADD		ESP,4			; INT 0x0d
	IRETD
.kill:
;	
	MOV		EAX,1*8			; OS DS/SS
	MOV		ES,AX
	MOV		SS,AX
	MOV		DS,AX
	MOV		FS,AX
	MOV		GS,AX
	MOV		ESP,[0xfe4]		; start_app
	STI						; 
	POPAD					; 
	RET