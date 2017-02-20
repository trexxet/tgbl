all:
	nasm -f bin main.asm -o test.bin
run: all
	qemu-system-i386 -m 32 -drive format=raw,file=test.bin
debug-bochs: all
	bochs -qf bochsrc-debug
