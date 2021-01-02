CC = gcc
CFLAGS = -c -m32 -nostdlib -fno-pic -fno-builtin -g

#--------------------
#	hankaku char
#--------------------
convHankakuTxt : convHankakuTxt.c 
	$(CC) $< -o $@

hankaku.c : hankaku.txt convHankakuTxt Makefile
	./convHankakuTxt

#--------------------
# os boot loader
#--------------------
ipl.bin : ipl.asm 
	nasm $< -o $@ -l ipl.lst

asmhead.bin : asmhead.asm
	nasm $< -o $@ -l asmhead.lst

nasmfunc.o : nasmfunc.asm
	nasm -f elf $< -o $@ -l nasmfunc.lst

#--------------------
# os system 
#--------------------
%.o : %.c
	$(CC) $(CFLAGS) $*.c -o $*.o

OBJS_BOOTPACK = bootpack.o nasmfunc.o hankaku.o fifo.o int.o keyboard.o \
	mouse.o memory.o mysprintf.o graphic.o dsctbl.o sheet.o timer.o \
	mtask.o console.o window.o file.o 
bootpack.hrb : $(OBJS_BOOTPACK) Makefile
	ld -m elf_i386 -T har.ld $(OBJS_BOOTPACK) -o $@ -M=bootpack.map

haribote.sys : ipl.bin asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::
	mcopy ipl.asm -i haribote.img ::
	mcopy make.bat -i haribote.img ::

#--------------------
#  
#--------------------
default :
	make run

img :
	make haribote.img

run :
	make img

debug:
	make img

clean :
	rm *.o
	rm *.lst
	rm *.bin
	rm *.hrb
	rm *.sys

src_only :
	rm haribote.img
	make clean
