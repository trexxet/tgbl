ASM = nasm -f bin -i "../lib/"
SRC = pictures

%.bin : %.asm
	$(ASM) $< -o $@
	dd if=/dev/zero of=$(SRC).img count=1008 bs=512
	dd if=$@ of=$(SRC).img conv=notrunc

all: $(SRC).bin

run: all
	qemu-system-i386 -s -m 32 -drive format=raw,file=$(SRC).bin

debug-bochs: all
	bochs -qf bochsrc-debug

clean:
	rm -f *.bin *.img
