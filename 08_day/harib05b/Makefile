CC = gcc
CFLAGS = -c -m32 -nostdlib -fno-pic

default :
	make run

#--------------------
#	hankaku char
#--------------------
convHankakuTxt : convHankakuTxt.c
	$(CC) $< -o $@

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

#--------------------
#--------------------
ipl.bin : ipl.asm
	nasm $< -o $@ -l $*.lst

asmhead.bin : asmhead.asm
	nasm $< -o $@ -l $*.lst

nasmfunc.o : nasmfunc.asm
	nasm -f elf $< -o $@ -l $*.lst

hankaku.o : hankaku.c
	$(CC) $(CFLAGS) hankaku.c -o hankaku.o
bootpack.o : bootpack.c
	$(CC) $(CFLAGS) bootpack.c -o bootpack.o
mysprintf.o : mysprintf.c
	$(CC) $(CFLAGS) -nostdlib $^ -o $@

fifo.o : fifo.c
	$(CC) $(CFLAGS) fifo.c -o fifo.o
int.o : int.c
	$(CC) $(CFLAGS) int.c -o int.o
#OBJS_BOOTPACK = bootpack.c nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o
#bootpack.hrb : $(OBJS_BOOTPACK) har.ld
#	$(CC) -m32 -march=i486 -nostdlib -nostdinc -T har.ld $(OBJS_BOOTPACK) -o $@
OBJS_BOOTPACK = bootpack.o nasmfunc.o hankaku.o fifo.o int.o mysprintf.o graphic.o dsctbl.o
bootpack.hrb : $(OBJS_BOOTPACK) har.ld
	ld -m elf_i386 -T har.ld $(OBJS_BOOTPACK) -o $@

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::

#--------------------
#--------------------
%.o : %.c
	$(CC) $(CFLAGS) $*.c -o $*.o

#--------------------
#--------------------
img :
	make haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img	# "-fda" for floppy disk

debug:
	make img
	qemu-system-i386 -fda haribote.img -gdb tcp::10000 -S

clean :
	rm *.o
	rm *.lst
	rm *.bin
	rm *.hrb
	rm *.sys

src_only :
	rm haribote.img
	make clean
