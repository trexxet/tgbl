# TGBL
##### Text & Graphics BIOS library

[MIGRATED](https://gitlab.com/trexxet/tgbl)

## What is it?
A library that helps you write assembler code for BIOS. </br>
It includes bootloader, functions and macros for printing strings, managing keyboard, drawing ASCII pictures, timers etc.

## How to use it?
Copy the `lib/` folder to your project's one and don't forget to set the `-i "lib/"` flag for NASM. Then take a look at the examples. </br>
Also you may check [project wiki](https://github.com/trexxet/tgbl/wiki). </br>
Moreover, TGBL has a [tool](https://github.com/trexxet/tgbl/tree/master/apet) for drawing ASCII-pictures.

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
