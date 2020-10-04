; haribote-ipl
; TAB=4

		ORG		0x7c00			; ±ÌvOªÇ±ÉÇÝÜêéÌ©

; ÈºÍWIÈFAT12tH[}bgtbs[fBXNÌ½ßÌLq

		JMP		entry
		DB		0x90
		DB		"HARIBOTE"		; u[gZN^Ì¼Oð©RÉ¢Äæ¢i8oCgj
		DW		512				; 1ZN^Ìå«³i512ÉµÈ¯êÎ¢¯È¢j
		DB		1				; NX^Ìå«³i1ZN^ÉµÈ¯êÎ¢¯È¢j
		DW		1				; FATªÇ±©çnÜé©iÊÍ1ZN^Ú©çÉ·éj
		DB		2				; FATÌÂi2ÉµÈ¯êÎ¢¯È¢j
		DW		224				; [gfBNgÌæÌå«³iÊÍ224GgÉ·éj
		DW		2880			; ±ÌhCuÌå«³i2880ZN^ÉµÈ¯êÎ¢¯È¢j
		DB		0xf0			; fBAÌ^Cvi0xf0ÉµÈ¯êÎ¢¯È¢j
		DW		9				; FATÌæÌ·³i9ZN^ÉµÈ¯êÎ¢¯È¢j
		DW		18				; 1gbNÉ¢­ÂÌZN^ª é©i18ÉµÈ¯êÎ¢¯È¢j
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
		MOV		AX,0			; WX^ú»
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX

;

		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0			; V_0
		MOV		DH,0			; wbh0
		MOV		CL,2			; ZN^2
readloop:
		MOV		SI,0			; ¸sñð¦éWX^
retry:
		MOV		AH,0x02			; AH=0x02 : fBXNÇÝÝ
		MOV		AL,1			; 1ZN^
		MOV		BX,0
		MOV		DL,0x00			; AhCu
		INT		0x13			; fBXNBIOSÄÑoµ
		JNC		next			; G[ª¨«È¯êÎnextÖ
		ADD		SI,1			; SIÉ1ð«·
		CMP		SI,5			; SIÆ5ðär
		JAE		error			; SI >= 5 ¾Á½çerrorÖ
		MOV		AH,0x00
		MOV		DL,0x00			; AhCu
		INT		0x13			; hCuÌZbg
		JMP		retry
next:
		MOV		AX,ES			; AhXð0x200ißé
		ADD		AX,0x0020
		MOV		ES,AX			;
		ADD		CL,1			;
		CMP		CL,18			;
		JBE		readloop		;

		JMP             success                 ; 成功

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
		ADD		SI,1			; SIÉ1ð«·
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			;
		MOV		BX,15			;
		INT		0x10			;
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; üsð2Â
		DB		"load error"
		DB		0x0a			; üs
		DB		0

		TIMES	0x1fe-($-$$) DB 0		;

		DB		0x55, 0xaa
