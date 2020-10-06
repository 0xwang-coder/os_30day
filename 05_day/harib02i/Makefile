# Makefile

CC = gcc
CFLAGS = -c -m32 -nostdlib

default:
	make run
#--------------------
#	hankaku char
#--------------------
convHankakuTxt : convHankakuTxt.c
	$(CC) $< -o $@

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt
#--------------------
#	haribote
#--------------------
ipl.bin: ipl.asm Makefile
	nasm ipl.asm -o ipl.bin -l ipl.lst
asmhead.bin: asmhead.asm Makefile
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst
naskfunc.o: naskfunc.asm Makefile
	nasm -g -f elf naskfunc.asm -o naskfunc.o
# bootpack.hrb : bootpack.c har.ld hankaku.c naskfunc.o Makefile
# 	gcc -m32 -nostdlib -fno-pic -T har.ld bootpack.c hankaku.c naskfunc.o -o bootpack.hrb

hankaku.o : hankaku.c
	$(CC) $(CFLAGS) hankaku.c -o hankaku.o
bootpack.o : bootpack.c
	$(CC) $(CFLAGS) bootpack.c -o bootpack.o
mysprintf.o : mysprintf.c
	$(CC) $(CFLAGS)  -fno-pic -nostdlib $^ -o $@
bootpack.hrb : bootpack.c hankaku.o naskfunc.o mysprintf.o har.ld
	$(CC) -m32  -fno-pic -nostdlib -nostdinc -T har.ld bootpack.c hankaku.o naskfunc.o mysprintf.o -o bootpack.hrb

haribote.sys: asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys
haribote.img: ipl.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i haribote.img :: 
	mcopy haribote.sys -i haribote.img :: 
asm:
	make -r ipl.bin
img: 
	make -r haribote.img
run:
	make img	
	qemu-system-i386 -fda haribote.img 
debug:
	make img
	qemu-system-i386 -fda haribote.img -gdb tcp::10000 -S

clean:
	rm *.lst *.bin *.sys *.img *.hrb *.o