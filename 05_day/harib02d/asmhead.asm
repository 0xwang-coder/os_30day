; haribote-os boot asm
; TAB=4

BOTPAK	EQU		0x00280000		; bootpack
DSKCAC	EQU		0x00100000		; 
DSKCAC0	EQU		0x00008000		; 

; 有关BOOT_INFO变量的声明
CYLS	EQU		0x0ff0			; 
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2			; 
SCRNX	EQU		0x0ff4			; 
SCRNY	EQU		0x0ff6			; 
VRAM	EQU		0x0ff8			; 

	ORG		0xc200				; asmhead.asm被加载到内存的地址

; VGA显卡

	MOV		AL,0x13				; VGA　320x200x8bit彩色
	MOV		AH,0x00
	INT		0x10
	MOV		BYTE [VMODE],8		; 画面模式
	MOV		WORD [SCRNX],320
	MOV		WORD [SCRNY],200
	MOV		DWORD [VRAM],0x000a0000

; BIOS获取键盘上各种LED的状态　

	MOV		AH,0x02
	INT		0x16 			; keyboard BIOS
	MOV		[LEDS],AL

; PIC关闭一切中断

	MOV		AL,0xff
	OUT		0x21,AL
	NOP						; 空操作，有些CPU不支持连续执行OUT
	OUT		0xa1,AL

	CLI						; 禁止CPU级别的中断，防止被打扰

; 为了让CPU可以访问1MB以上的内存，需要设定A20GATE

	CALL	waitkbdout
	MOV		AL,0xd1
	OUT		0x64,AL
	CALL	waitkbdout
	MOV		AL,0xdf			; 开启A20信号线，使CPU可以访问1MB以上内存
	OUT		0x60,AL
	CALL	waitkbdout

; 切换到保护模式
	LGDT	[GDTR0]			;
	MOV		EAX,CR0
	AND		EAX,0x7fffffff	;
	OR		EAX,0x00000001	;
	MOV		CR0,EAX
	JMP		pipelineflush
pipelineflush:
	MOV		AX,1*8			;
	MOV		DS,AX
	MOV		ES,AX
	MOV		FS,AX
	MOV		GS,AX
	MOV		SS,AX

; 复制bootpack

	MOV		ESI,bootpack	; 
	MOV		EDI,BOTPAK		; 
	MOV		ECX,512*1024/4
	CALL	memcpy

; 复制启动区扇区

	MOV		ESI,0x7c00		; 
	MOV		EDI,DSKCAC		; 
	MOV		ECX,512/4
	CALL	memcpy

; 复制启动区扇区之外的运行程序

	MOV		ESI,DSKCAC0+512	; 
	MOV		EDI,DSKCAC+512	; 
	MOV		ECX,0
	MOV		CL,BYTE [CYLS]
	IMUL	ECX,512*18*2/4	;
	SUB		ECX,512/4		;
	CALL	memcpy

; bootpack的启动

	MOV		EBX,BOTPAK
	MOV		ECX,[EBX+16]
	ADD		ECX,3			; ECX += 3;
	SHR		ECX,2			; ECX /= 4;
	JZ		skip			; 
	MOV		ESI,[EBX+20]	; 
	ADD		ESI,EBX
	MOV		EDI,[EBX+12]	; 
	CALL	memcpy
skip:
	MOV		ESP,[EBX+12]	;
	JMP		DWORD 2*8:0x0000001b

waitkbdout:
	IN		 AL,0x64
	AND		 AL,0x02
	JNZ		waitkbdout		;
	RET

memcpy:
	MOV		EAX,[ESI]
	ADD		ESI,4
	MOV		[EDI],EAX
	ADD		EDI,4
	SUB		ECX,1
	JNZ		memcpy			;
	RET

;

	ALIGNB	16
GDT0:
	TIMES	8  DB 0				;
	DW		0xffff,0x0000,0x9200,0x00cf	;
	DW		0xffff,0x0000,0x9a28,0x0047	;

	DW		0
GDTR0:
	DW		8*3-1
	DD		GDT0

	ALIGNB	16
bootpack:
