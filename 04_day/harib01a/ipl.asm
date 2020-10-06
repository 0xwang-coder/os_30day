; haribote-ipl
; TAB=4

CYLS	EQU		10				;

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
	TIMES	18	DB  0			;

; �v���O�����{��

entry:
	MOV		AX,0			; ���W�X�^������
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX

; �f�B�X�N��ǂ�

	MOV		AX,0x0820
	MOV		ES,AX
	MOV		CH,0			; �V�����_0
	MOV		DH,0			; �w�b�h0
	MOV		CL,2			; �Z�N�^2
readloop:
		MOV		SI,0			; ���s�񐔂𐔂��郌�W�X�^
retry:
		MOV		AH,0x02			; AH=0x02 : �f�B�X�N�ǂݍ���
		MOV		AL,1			; 1�Z�N�^
		MOV		BX,0
		MOV		DL,0x00			; A�h���C�u
		INT		0x13			; �f�B�X�NBIOS�Ăяo��
		JNC		next			; �G���[�������Ȃ����next��
		ADD		SI,1			; SI��1�𑫂�
		CMP		SI,5			; SI��5���r
		JAE		error			; SI >= 5 ��������error��
		MOV		AH,0x00
		MOV		DL,0x00			; A�h���C�u
		INT		0x13			; �h���C�u�̃��Z�b�g
		JMP		retry
next:
		MOV		AX,ES			; �A�h���X��0x200�i�߂�
		ADD		AX,0x0020
		MOV		ES,AX			; ADD ES,0x020 �Ƃ������߂��Ȃ��̂ł������Ă���
		ADD		CL,1			; CL��1�𑫂�
		CMP		CL,18			; CL��18���r
		JBE		readloop		; CL <= 18 ��������readloop��
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop		; DH < 2 ��������readloop��
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop		; CH < CYLS ��������readloop��

;

		MOV		[0x0ff0],CH		; IPL���ǂ��܂œǂ񂾂̂�������
		JMP		0xc200

error:
		MOV		SI,msg
putloop:
	MOV		AL,[SI]
	ADD		SI,1			; SI��1�𑫂�
	CMP		AL,0
	JE		fin
	MOV		AH,0x0e			; �ꕶ���\���t�@���N�V����
	MOV		BX,15			; �J���[�R�[�h
	INT		0x10			; �r�f�IBIOS�Ăяo��
	JMP		putloop
fin:
	HLT						; ��������܂�CPU���~������
	JMP		fin				; �������[�v
msg:
	DB		0x0a, 0x0a		; ���s��2��
	DB		"load error"
	DB		0x0a			; ���s
	DB		0

	TIMES	0x1fe-($-$$)  DB 0		;

	DB		0x55, 0xaa
