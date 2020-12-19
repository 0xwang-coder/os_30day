CC = gcc
CFLAGS = -c -m32 -nostdlib -fno-pic -fno-builtin

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

hlt.hrb : hlt.asm
	nasm -f elf $< -o $@ -l $*.lst

hankaku.o : hankaku.c
	$(CC) $(CFLAGS) hankaku.c -o hankaku.o
bootpack.o : bootpack.c
	$(CC) $(CFLAGS) bootpack.c -o bootpack.o
mysprintf.o : mysprintf.c
	$(CC) $(CFLAGS) $^ -o $@

fifo.o : fifo.c
	$(CC) $(CFLAGS) fifo.c -o fifo.o
int.o : int.c
	$(CC) $(CFLAGS) int.c -o int.o
keyboard.o : keyboard.c
	$(CC) $(CFLAGS) keyboard.c -o keyboard.o
mouse.o : mouse.c
	$(CC) $(CFLAGS) mouse.c -o mouse.o
memory.o : memory.c
	$(CC) $(CFLAGS) memory.c -o memory.o
sheet.o : sheet.c
	$(CC) $(CFLAGS) sheet.c -o sheet.o
timer.o : timer.c
	$(CC) $(CFLAGS) timer.c -o timer.o
mtask.o : mtask.c
	$(CC) $(CFLAGS) mtask.c -o mtask.o
console.o : console.c
	$(CC) $(CFLAGS) console.c -o console.o
dsctbl.o : dsctbl.c
	$(CC) $(CFLAGS) dsctbl.c -o dsctbl.o
#OBJS_BOOTPACK = bootpack.c nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o
#bootpack.hrb : $(OBJS_BOOTPACK) har.ld
#	$(CC) -m32 -march=i486 -nostdlib -nostdinc -T har.ld $(OBJS_BOOTPACK) -o $@
OBJS_BOOTPACK = bootpack.o nasmfunc.o hankaku.o fifo.o int.o keyboard.o \
	mouse.o memory.o mysprintf.o graphic.o dsctbl.o sheet.o timer.o \
	mtask.o console.o window.o file.o hlt.hrb
bootpack.hrb : $(OBJS_BOOTPACK) har.ld
	ld -m elf_i386 -T har.ld $(OBJS_BOOTPACK) -o $@

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::
	mcopy ipl.asm -i haribote.img ::
	mcopy make.bat -i haribote.img ::
	mcopy hlt.hrb -i haribote.img ::

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
	qemu-system-i386 -fda haribote.img -monitor stdio -show-cursor

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
