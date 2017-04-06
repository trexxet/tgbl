ASM = nasm -f bin -i "../lib/"
SRC = main

%.bin : %.asm
	$(ASM) $< -o $@

all: $(SRC).bin

run: all
	qemu-system-i386 -m 32 -drive format=raw,file=$(SRC).bin

debug-bochs: all
	bochs -qf bochsrc-debug

clean:
	rm -f ./*.bin
