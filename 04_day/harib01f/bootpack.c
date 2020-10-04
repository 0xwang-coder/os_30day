void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);

void HariMain(void)
{
	int i;
	char *p;
	// 初始化
	// init_palette();

	p = (char *)0xa0000;
	for (i = 0; i <= 0xffff; i++)
	{
		p[i] = i & 0x0f;
	}

	for (;;)
	{
		io_hlt();
	}
}

void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00, /*  0:�� */
		0xff, 0x00, 0x00, /*  1:���邢�� */
		0x00, 0xff, 0x00, /*  2:���邢�� */
		0xff, 0xff, 0x00, /*  3:���邢���F */
		0x00, 0x00, 0xff, /*  4:���邢�� */
		0xff, 0x00, 0xff, /*  5:���邢�� */
		0x00, 0xff, 0xff, /*  6:���邢���F */
		0xff, 0xff, 0xff, /*  7:�� */
		0xc6, 0xc6, 0xc6, /*  8:���邢�D�F */
		0x84, 0x00, 0x00, /*  9:�Â��� */
		0x00, 0x84, 0x00, /* 10:�Â��� */
		0x84, 0x84, 0x00, /* 11:�Â����F */
		0x00, 0x00, 0x84, /* 12:�Â��� */
		0x84, 0x00, 0x84, /* 13:�Â��� */
		0x00, 0x84, 0x84, /* 14:�Â����F */
		0x84, 0x84, 0x84  /* 15:�Â��D�F */
	};
	set_palette(0, 15, table_rgb);
	return;
}

void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags();
	io_cli();
	io_out8(0x03c8, start);
	for (i = start; i <= end; i++)
	{
		// 
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	io_store_eflags(eflags);
	return;
}
