; haribote-ipl
; TAB=4

	ORG		0x7c00			;

;

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
	TIMES	18	DB 0			;

;

entry:
	MOV		AX,0			; 初始化寄存器
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX

; 读取磁盘1个扇区＝512字节

	MOV		AX,0x0820		
	MOV		ES,AX
	MOV		CH,0			; 柱面
	MOV		DH,0			; 磁头
	MOV		CL,2			; 扇区

	MOV		AH,0x02			; AH=0x02:读盘 0x03:写盘 0x04:校验 0x0c:寻道
	MOV		AL,1			; 1个扇区
	MOV		BX,0
	MOV		DL,0x00			; A驱动器
	INT		0x13			; 调用磁盘BIOS
	JC		error			; 如果读盘失败，跳转显示错误

; 读盘成功进入休眠

fin:
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
