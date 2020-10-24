#include "bootpack.h"
#include <stdio.h>

void init_pic(void)
{
	io_out8(PIC0_IMR,  0xff  ); /* �S�Ă̊��荞�݂��󂯕t���Ȃ� */
	io_out8(PIC1_IMR,  0xff  ); /* �S�Ă̊��荞�݂��󂯕t���Ȃ� */

	io_out8(PIC0_ICW1, 0x11  ); /* �G�b�W�g���K���[�h */
	io_out8(PIC0_ICW2, 0x20  ); /* IRQ0-7�́AINT20-27�Ŏ󂯂� */
	io_out8(PIC0_ICW3, 1 << 2); /* PIC1��IRQ2�ɂĐڑ� */
	io_out8(PIC0_ICW4, 0x01  ); /* �m���o�b�t�@���[�h */

	io_out8(PIC1_ICW1, 0x11  ); /* �G�b�W�g���K���[�h */
	io_out8(PIC1_ICW2, 0x28  ); /* IRQ8-15�́AINT28-2f�Ŏ󂯂� */
	io_out8(PIC1_ICW3, 2     ); /* PIC1��IRQ2�ɂĐڑ� */
	io_out8(PIC1_ICW4, 0x01  ); /* �m���o�b�t�@���[�h */

	io_out8(PIC0_IMR,  0xfb  ); /* 11111011 PIC1�ȊO�͑S�ċ֎~ */
	io_out8(PIC1_IMR,  0xff  ); /* 11111111 �S�Ă̊��荞�݂��󂯕t���Ȃ� */

	return;
}

#define PORT_KEYDAT		0x0060
struct FIFO8 keyfifo;
struct FIFO8 mousefifo;

void inthandler21(int *esp)
{
	unsigned char data;
	io_out8(PIC0_OCW2, 0x61);	/* IRQ-01 */
	data = io_in8(PORT_KEYDAT);
	fifo8_put(&keyfifo, data);
	return;
}

void inthandler2c(int *esp)
{
	unsigned char data;
	io_out8(PIC1_OCW2, 0x64);	/* IRQ-12 */
	io_out8(PIC0_OCW2, 0x62);	/* IRQ-02 */
	data = io_in8(PORT_KEYDAT);
	fifo8_put(&mousefifo, data);
	return;
}

void inthandler27(int *esp)
{
	io_out8(PIC0_OCW2, 0x67); /* IRQ-07 */
	return;
}
