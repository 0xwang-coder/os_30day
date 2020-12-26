#include "bootpack.h"
#include <stdio.h>

/**
 * PIC
 */
void init_pic(void)
{
	io_out8(PIC0_IMR,  0xff  ); 
	io_out8(PIC1_IMR,  0xff  ); 

	io_out8(PIC0_ICW1, 0x11  ); 
	io_out8(PIC0_ICW2, 0x20  ); /* IRQ0-7 AINT20-27 */
	io_out8(PIC0_ICW3, 1 << 2); /* PIC1 IRQ */
	io_out8(PIC0_ICW4, 0x01  ); 

	io_out8(PIC1_ICW1, 0x11  ); 
	io_out8(PIC1_ICW2, 0x28  ); /* IRQ8-15�́AINT28-2f */
	io_out8(PIC1_ICW3, 2     ); /* PIC1 */
	io_out8(PIC1_ICW4, 0x01  );

	io_out8(PIC0_IMR,  0xfb  ); /* 11111011 PIC1 */
	io_out8(PIC1_IMR,  0xff  ); /* 11111111 */

	return;
}

void inthandler27(int *esp)
{
	io_out8(PIC0_OCW2, 0x67); /* IRQ-07 */
	return;
}
