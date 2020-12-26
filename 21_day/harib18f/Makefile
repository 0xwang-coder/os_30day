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
hello.o : hello.asm
	nasm -f elf $< -o $@ -l hello.lst
hello.hrb: hello.o Makefile
	ld -m elf_i386 -T hello.ld hello.o -o hello.hrb -M=hello.map
crack2.o : crack2.asm
	nasm -f elf $< -o $@ -l crack2.lst
crack2.hrb: crack2.o Makefile
	ld -m elf_i386 -T crack2.ld crack2.o -o crack2.hrb -M=crack2.map

#OBJS_BOOTPACK = bootpack.c nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o
#bootpack.hrb : $(OBJS_BOOTPACK) har.ld
#	$(CC) -m32 -march=i486 -nostdlib -nostdinc -T har.ld $(OBJS_BOOTPACK) -o $@
OBJS_BOOTPACK = bootpack.o nasmfunc.o hankaku.o fifo.o int.o keyboard.o \
	mouse.o memory.o mysprintf.o graphic.o dsctbl.o sheet.o timer.o \
	mtask.o console.o window.o file.o 
bootpack.hrb : $(OBJS_BOOTPACK) hello.hrb crack2.hrb Makefile
	ld -m elf_i386 -T har.ld $(OBJS_BOOTPACK) -o $@ -M=bootpack.map

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::
	mcopy ipl.asm -i haribote.img ::
	mcopy make.bat -i haribote.img ::
	mcopy hello.hrb -i haribote.img ::
	mcopy crack2.hrb -i haribote.img ::

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
