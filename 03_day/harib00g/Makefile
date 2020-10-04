subdir=./kernel
all:img
boot:
	nasm -o bootloader ipl.asm
	nasm -o haribote.sys haribote.asm
img:boot
	dd if=bootloader of=ipl.img count=1 bs=512
	dd if=/dev/zero of=ipl.img bs=512 seek=1 skip=1 count=2879
copy:
	mkdir -p /tmp/floppy
	mount -o loop ipl.img /tmp/floppy -o fat=12
	sleep 1
	cp haribote.sys /tmp/floppy
	sleep 1
	#umount /tmp/floppy
run:
	qemu-system-x86_64 -drive file=ipl.img,if=floppy,media=disk,format=raw
clean:
	rm bootloader ipl.img haribote.sys
