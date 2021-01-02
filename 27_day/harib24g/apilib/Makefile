#--------------------
# api -T api.ld 
#--------------------
OBJS_API = api001.o api002.o api004.o api005.o api015.o
%.o : %.asm
	nasm -f elf $*.asm -o $*.o -l $*.lst 
apilib.lib: $(OBJS_API)
	ld -m elf_i386 $(OBJS_API) -o apilib.lib -M=apilib.map

#--------------------
#  
#--------------------
default :
	make run

run :
	make apilib.lib

clean :
	rm *.o
	rm *.lst
	rm *.map
	rm *.lib

src_only :
	rm haribote.img
	make clean
