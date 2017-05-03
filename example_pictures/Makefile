ASM = nasm -f bin -i "../lib/"
SRC = pictures

%.bin : %.asm
	$(ASM) $< -o $@

all: $(SRC).bin

run: all
	qemu-system-i386 -m 32 -drive format=raw,file=$(SRC).bin

clean:
	rm -f ./pictures.bin
