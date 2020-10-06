; haribote-ipl
; TAB=4

	ORG		0x7c00			; ±ÌvOªÇ±ÉÇÝÜêéÌ©

; ÈºÍWIÈFAT12tH[}bgtbs[fBXNÌ½ßÌLq

	JMP		entry
	DB		0x90
	DB		"HARIBOTE"		; 
	DW		512				; 
	DB		1				; 
	DW		1				; 
	DB		2				; 
	DW		224				; 
	DW		2880			; 
	DB		0xf0			; 
	DW		9				; 
	DW		18				; 
	DW		2				;
	DD		0				;
	DD		2880			;
	DB		0,0,0x29		;
	DD		0xffffffff		;
	DB		"HARIBOTEOS "	;
	DB		"FAT12   "		;
	TIMES	18 DB 0

;

entry:
	MOV		AX,0			; 
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX

; 读盘

	MOV		AX,0x0820
	MOV		ES,AX
	MOV		CH,0			; 
	MOV		DH,0			; 
	MOV		CL,2			; 
readloop:
	MOV		SI,0			; 记录读盘失败次数的寄存器
retry:
	MOV		AH,0x02			; 
	MOV		AL,1			; 
	MOV		BX,0
	MOV		DL,0x00			; 
	INT		0x13			; 
	JNC		next			; 读盘成功则继续
	ADD		SI,1			; 读盘失败则重试5次
	CMP		SI,5			; 
	JAE		error			; 重试5次后仍然失败则跳转到'load error'
	MOV		AH,0x00
	MOV		DL,0x00			; 
	INT		0x13			; 重试未满5次则重置驱动器后继续重试
	JMP		retry
next:
	MOV		AX,ES			; 内存地址后移0x200
	ADD		AX,0x0020
	MOV		ES,AX			;
	ADD		CL,1			;
	CMP		CL,18			;
	JBE		readloop		;

	JMP     success         ; 成功

success:
	MOV SI, success_msg

success_msg:
	DB  0x0a, 0x0a
	DB "hello love"
	DB 0x0a
	DB 0

fin:
	; DB 0x0a, 0x0a
	; DB "hello love"
	; DB 0x0a
	; DB 0
	HLT						;
	JMP		fin				;

error:
	MOV		SI,msg
putloop:
	MOV		AL,[SI]
	ADD		SI,1			;
	CMP		AL,0
	JE		fin
	MOV		AH,0x0e			;
	MOV		BX,15			;
	INT		0x10			;
	JMP		putloop
msg:
	DB		0x0a, 0x0a		; 
	DB		"load error"
	DB		0x0a			; 
	DB		0

	TIMES	0x1fe-($-$$) DB 0		;

	DB		0x55, 0xaa
