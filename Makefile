ASM = nasm -f bin

%.bin : %.asm
	$(ASM) $< -o $@

all: main.bin

run: all
	qemu-system-i386 -m 32 -drive format=raw,file=main.bin

debug-bochs: all
	bochs -qf bochsrc-debug

clean:
	rm -f ./*.bin