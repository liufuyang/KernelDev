CFLAGS  := -fno-stack-protector -fno-builtin -nostdinc -O -g -Wall -I. -I./include
LDFLAGS := -nostdlib -Wl,-N -Wl,-Ttext -Wl,100000
INCLUDE_HEAD := include/system.h
OBJ_DIR := object

all:	kernel.bin

kernel.bin:	start.o	main.o scrn.o gdt.o idt.o irq.o isrs.o	
	ld -T link.ld -o kernel.bin start.o main.o scrn.o gdt.o idt.o irq.o isrs.o
	@echo Link Successful!

kernel2.bin: start.asm main.c scrn.c start.o 
	gcc -o kernel.bin $(CFLAGS) start.o main.c scrn.c $(LDFLAGS)


start.o: start.asm
	nasm  -f elf -o start.o start.asm

main.o: main.c $(INCLUDE_HEAD)
	gcc $(CFLAGS) -c -o main.o main.c

scrn.o: scrn.c $(INCLUDE_HEAD)
	gcc $(CFLAGS) -c -o scrn.o scrn.c

gdt.o: gdt.c $(INCLUDE_HEAD)
	gcc $(CFLAGS) -c -o gdt.o gdt.c

idt.o: idt.c $(INCLUDE_HEAD) 
	gcc $(CFLAGS) -c -o idt.o idt.c

irq.o: irq.c $(INCLUDE_HEAD)
	gcc $(CFLAGS) -c -o irq.o irq.c

isrs.o: isrs.c $(INCLUDE_HEAD)
	gcc $(CFLAGS) -c -o isrs.o isrs.c

easy: all
	@sudo cp kernel.bin ../floppy/kernel.rc.bin
	@echo Copy kernel.bin to `pwd`/../floopy/kernel.rc.bin

clean: 
	rm -f *.o *.bin
cleanobj:
	rm -f *.o
