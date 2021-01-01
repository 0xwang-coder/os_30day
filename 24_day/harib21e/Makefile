CC = gcc
CFLAGS = -c -m32 -nostdlib -fno-pic -fno-builtin -g

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

#--------------------
# exec
#--------------------
a_nask.o : a_nask.asm
	nasm -f elf $< -o $@ -l a_nask.lst
walk.hrb: walk.o a_nask.o Makefile
	ld -m elf_i386 -T har.ld a_nask.o walk.o -o walk.hrb -M=walk.map
lines.hrb: lines.o a_nask.o Makefile
	ld -m elf_i386 -T har.ld a_nask.o lines.o -o lines.hrb -M=lines.map
stars2.hrb: stars2.o a_nask.o Makefile
	ld -m elf_i386 -T har.ld a_nask.o mysprintf.o stars2.o -o stars2.hrb -M=stars2.map

#OBJS_BOOTPACK = bootpack.c nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o
#bootpack.hrb : $(OBJS_BOOTPACK) har.ld
#	$(CC) -m32 -march=i486 -nostdlib -nostdinc -T har.ld $(OBJS_BOOTPACK) -o $@
OBJS_BOOTPACK = bootpack.o nasmfunc.o hankaku.o fifo.o int.o keyboard.o \
	mouse.o memory.o mysprintf.o graphic.o dsctbl.o sheet.o timer.o \
	mtask.o console.o window.o file.o 
bootpack.hrb : $(OBJS_BOOTPACK) Makefile
	ld -m elf_i386 -T har.ld $(OBJS_BOOTPACK) -o $@ -M=bootpack.map

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl.bin haribote.sys walk.hrb lines.hrb stars2.hrb Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::
	mcopy ipl.asm -i haribote.img ::
	mcopy make.bat -i haribote.img ::
	mcopy walk.hrb -i haribote.img ::
	mcopy lines.hrb -i haribote.img ::
	mcopy stars2.hrb -i haribote.img ::

#--------------------
#  debug -gdb tcp::10000
#--------------------
img :
	make haribote.img

run :
	make img
	qemu-system-i386 -fda haribote.img -monitor stdio -show-cursor

debug:
	make img
	qemu-system-i386 -S -fda haribote.img -gdb tcp::10000 -monitor stdio -show-cursor

clean :
	rm *.o
	rm *.lst
	rm *.bin
	rm *.hrb
	rm *.sys

src_only :
	rm haribote.img
	make clean
