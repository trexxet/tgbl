# TGBL
##### Text & Graphics BIOS library

## What is it?
A set of functions & macros helping you write less and write fast.

## How to use it?
Copy the ```lib/``` folder to your project's one. Then take a look at the example in ```main.asm```

## Building sample program and running
* ```$ make``` to get a main.bin
* ```$ make run``` to build and launch QEMU

#### Running from emulator
TGBL was tested on QEMU and Bochs. However, implementation on Bochs is extremely slow and using QEMU is recomended. However, you may use Bochs for debug.

## Requirements
* nasm
* QEMU (to test your programs)
