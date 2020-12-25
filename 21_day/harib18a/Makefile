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
#   
#--------------------
ipl.bin : ipl.asm
	nasm $< -o $@ -l ipl.lst

asmhead.bin : asmhead.asm
	nasm $< -o $@ -l asmhead.lst

nasmfunc.o : nasmfunc.asm
	nasm -f elf $< -o $@ -l nasmfunc.lst

#--------------------
# exec
#--------------------
hello.o : hello.asm
	nasm -f elf $< -o $@ -l hello.lst
hello2.o : hello2.asm
	nasm -f elf $< -o $@ -l hello2.lst
hello.hrb: hello.o Makefile
	ld -m elf_i386 -T hlt.ld hello.o -o hello.hrb -M=hello.map
hello2.hrb: hello2.o Makefile
	ld -m elf_i386 -T hlt.ld hello2.o -o hello2.hrb -M=hello2.map

hankaku.o : hankaku.c
	$(CC) $(CFLAGS) hankaku.c -o hankaku.o
bootpack.o : bootpack.c
	$(CC) $(CFLAGS) bootpack.c -o bootpack.o
mysprintf.o : mysprintf.c
	$(CC) $(CFLAGS) $^ -o $@

#--------------------
# 
#--------------------
%.o : %.c
	$(CC) $(CFLAGS) $*.c -o $*.o

#OBJS_BOOTPACK = bootpack.c nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o
#bootpack.hrb : $(OBJS_BOOTPACK) har.ld
#	$(CC) -m32 -march=i486 -nostdlib -nostdinc -T har.ld $(OBJS_BOOTPACK) -o $@
OBJS_BOOTPACK = bootpack.o nasmfunc.o hankaku.o fifo.o int.o keyboard.o \
	mouse.o memory.o mysprintf.o graphic.o dsctbl.o sheet.o timer.o \
	mtask.o console.o window.o file.o 
bootpack.hrb : $(OBJS_BOOTPACK) har.ld hello.hrb hello2.hrb Makefile
	ld -m elf_i386 -T har.ld $(OBJS_BOOTPACK) -o $@ -M=bootpack.map

haribote.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img ::
	mcopy haribote.sys -i haribote.img ::
	mcopy ipl.asm -i haribote.img ::
	mcopy make.bat -i haribote.img ::
	mcopy hello.hrb -i haribote.img ::
	mcopy hello2.hrb -i haribote.img ::

#--------------------
#  
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
