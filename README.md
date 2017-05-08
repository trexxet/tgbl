# TGBL
##### Text & Graphics BIOS library

## What is it?
A set of functions & macros helping you write less and write fast.

## How to use it?
Copy the `lib/` folder to your project's one and don't forget to set the `-i "lib/"` flag for NASM. Then take a look at the examples.

## Building sample program and running
Cd into any example, then:
* `$ make` to get a binary
* `$ make run` to build and launch QEMU
* `# dd if=%binary name% of=%device name% bs=512` to write a binary to device

#### Running from emulator
TGBL was tested on QEMU.

## Requirements
* nasm
* QEMU (to test your programs)
