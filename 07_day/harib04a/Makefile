# Makefile

#  -static
CC = gcc
CFLAGS = -c -m32 -fno-pic -nostdlib -std=c99

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
	$(CC) $(CFLAGS) $^ -o $@
int.o : int.c
	$(CC) $(CFLAGS) int.c -o int.o
	
#OBJS_BOOTPACK = bootpack.c nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o
#bootpack.hrb : $(OBJS_BOOTPACK) har.ld
#	$(CC) -m32 -march=i486 -nostdlib -nostdinc -T har.ld /usr/lib32/crt1.o /usr/lib32/crti.o /usr/lib32/crtbegin*.o /usr/lib32/crtend*.o
OBJS_BOOTPACK = bootpack.o nasmfunc.o hankaku.o int.o graphic.o dsctbl.o 
# -fno-pie -shared -dynamic-linker /usr/lib32/ld-linux.so.2 -lgcc_eh 
bootpack.hrb : $(OBJS_BOOTPACK) har.ld
	# ld -m elf_i386 -fno-pic -shared -L/usr/lib32 -T har.ld $(OBJS_BOOTPACK) -o $@ \
	# -lc -lg -ldl -lgcc -lgcc_eh
	# 解决无法链接libdl.a的问题  -fno-pie 
	ld -static -m elf_i386 -shared -fno-pic -L/usr/lib32 -T har.ld $(OBJS_BOOTPACK)  -o $@ \
	--start-group /usr/lib32/libdl.a /usr/lib32/libgcc.a /usr/lib32/libgcc_eh.a /usr/lib32/libc.a --end-group

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
