# TGBL
##### Text & Graphics BIOS library

## What is it?
A set of functions & macros helping you write less and write fast.

## How to use it?
Copy the `lib/` folder to your project's one and don't forget to set the `-i "lib/"` flag for NASM. Then take a look at the examples.

## Building sample program and running
Cd into the 'example', then:
* `$ make` to get a main.bin
* `$ make run` to build and launch QEMU

#### Running from emulator
TGBL was tested on QEMU and Bochs. Implementation on Bochs is extremely slow and using QEMU is recommended. However, you may use Bochs for debug.

## Requirements
* nasm
* QEMU (to test your programs)
